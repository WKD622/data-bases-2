-- Zmiana struktury bazy danych, w tabeli wycieczki dodajemy redundantne pole
-- liczba_wolnych_miejsc

CREATE TABLE WYCIECZKI
(
  ID_WYCIECZKI          INT GENERATED ALWAYS AS IDENTITY NOT NULL
  ,
  NAZWA                 VARCHAR2(100)
  ,
  KRAJ                  VARCHAR2(50)
  ,
  DATA                  DATE
  ,
  OPIS                  VARCHAR2(200)
  ,
  LICZBA_MIEJSC         INT
  ,
  LICZBA_WOLNYCH_MIEJSC INT
  ,
  CONSTRAINT WYCIECZKI_PK PRIMARY KEY
    (
      ID_WYCIECZKI
    )
  ENABLE
);

-- Należy zmodyfikować zestaw widoków. Proponuję dodać kolejne widoki (np. z sufiksem 2), które
-- pobierają informację o wolnych miejscach z nowo dodanego pola.

create view dostepne_wycieczki_2 as
  select *
  from wycieczki w
  where w.LICZBA_WOLNYCH_MIEJSC > 0
    and w.DATA > (select current_date from dual)

-- Należy napisać procedurę przelicz która zaktualizuje wartość liczby wolnych miejsc dla już
-- istniejących danych

create or replace procedure przelicz as
  begin
    declare
      VAL number;
    begin
      FOR REC IN (SELECT w.ID_WYCIECZKI, w.LICZBA_MIEJSC -
                                         NVL((select count(*)
                                              from REZERWACJE r
                                              where w.ID_WYCIECZKI = r.ID_WYCIECZKI
                                              group by r.ID_WYCIECZKI),
                                             0) LICZBA_MIEJSC_WOLNYCH
                  from WYCIECZKI w)
      LOOP
        UPDATE WYCIECZKI s
        SET s.LICZBA_WOLNYCH_MIEJSC = REC.LICZBA_MIEJSC_WOLNYCH
        WHERE s.ID_WYCIECZKI = REC.ID_WYCIECZKI;
      END LOOP;
    end;
  end;

-- Należy zmodyfikować warstwę procedur pobierających dane, podobnie jak w przypadku
-- widoków.
-- Należy zmodyfikować procedury wprowadzające dane tak aby korzystały/aktualizowały pole
-- liczba _wolnych_miejsc w tabeli wycieczki
-- Najlepiej to zrobić tworząc nowe wersje (np. z sufiksem 2)
