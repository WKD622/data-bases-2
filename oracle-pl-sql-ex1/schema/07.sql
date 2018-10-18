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
create or replace function dostepne_miejsca_2(id_w NUMBER)
  return NUMBER
is
  liczba_wolnych_miejsc_ number;
  begin
    select w.LICZBA_WOLNYCH_MIEJSC into liczba_wolnych_miejsc_ from WYCIECZKI w where w.ID_WYCIECZKI = id_w;
    return liczba_wolnych_miejsc_;
  end;


create or replace function dostepne_wycieczki_2_(kraj_ varchar2, data_od date, data_do date)
  return tab_dostepne_wycieczki pipelined
as
  begin
    for x in (select w.KRAJ, w.DATA
              from WYCIECZKI w
              where w.LICZBA_WOLNYCH_MIEJSC > 0
                and (select CURRENT_DATE from DUAL) < w.DATA
                and w.DATA between data_od and data_do
                and w.KRAJ = kraj_)
    loop
      pipe row (type_dostepne_wycieczki(x.KRAJ, x.DATA));
    end loop;
    return;
  end;


-- Należy zmodyfikować procedury wprowadzające dane tak aby korzystały/aktualizowały pole
-- liczba _wolnych_miejsc w tabeli wycieczki
-- Najlepiej to zrobić tworząc nowe wersje (np. z sufiksem 2)

create or replace procedure dodaj_rezerwacje_2(id_w NUMBER, id_o NUMBER)
as
  begin
    declare
      wycieczki NUMBER;
      osoba     NUMBER;
    begin

      select count(w.id_wycieczki) into wycieczki from WYCIECZKI w where w.ID_WYCIECZKI = id_w;
      select o.id_osoby into osoba from OSOBY o where o.id_osoby = id_o;

      if wycieczki > 0 and osoba > 0
      then
        INSERT INTO rezerwacje (id_wycieczki, id_osoby, status) VALUES (id_w, id_o, 'N');
        begin
          przelicz();
        end;
      end if;
    end;
  end;

create procedure zmien_liczbe_miejsc_2(id_wycieczki_ NUMBER, nowa_liczba_miejsc NUMBER)
as
  begin
    declare
      calkowita_liczba_miejsc NUMBER;
      dostepne_miejsca_       NUMBER;
    begin
      select w.LICZBA_MIEJSC into calkowita_liczba_miejsc from WYCIECZKI w where w.ID_WYCIECZKI = id_wycieczki_;
      select dostepne_miejsca(id_wycieczki_) into dostepne_miejsca_ from dual;
      if (nowa_liczba_miejsc >= (calkowita_liczba_miejsc - dostepne_miejsca_))
      then
        update WYCIECZKI w set w.LICZBA_MIEJSC = nowa_liczba_miejsc where w.ID_WYCIECZKI = id_wycieczki;
        begin
          przelicz();
        end;
      end if;
    end;
  end;
