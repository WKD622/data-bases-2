CREATE OR REPLACE TABLE OSOBY
(
 ID_OSOBY INT GENERATED ALWAYS AS IDENTITY NOT NULL
, IMIE VARCHAR2(50)
, NAZWISKO VARCHAR2(50)
, PESEL VARCHAR2(11)
, KONTAKT VARCHAR2(100)
, CONSTRAINT OSOBY_PK PRIMARY KEY
 (
 ID_OSOBY
 )
 ENABLE
);

CREATE OR REPLACE TABLE WYCIECZKI
(
 ID_WYCIECZKI INT GENERATED ALWAYS AS IDENTITY NOT NULL
, NAZWA VARCHAR2(100)
, KRAJ VARCHAR2(50)
, DATA DATE
, OPIS VARCHAR2(200)
, LICZBA_MIEJSC INT
, CONSTRAINT WYCIECZKI_PK PRIMARY KEY
 (
 ID_WYCIECZKI
 )
 ENABLE
);

CREATE OR REPLACE TABLE REZERWACJE
(
 NR_REZERWACJI INT GENERATED ALWAYS AS IDENTITY NOT NULL
, ID_WYCIECZKI INT
, ID_OSOBY INT
, STATUS CHAR(1)
, CONSTRAINT REZERWACJE_PK PRIMARY KEY
 (
 NR_REZERWACJI
 )
 ENABLE
);


INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES('Adam', 'Kowalski', '87654321', 'tel: 6623');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES('Jan', 'Nowak', '12345678', 'tel: 2312, dzwonić po 18.00');
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Wycieczka do Paryza','Francja',TO_DATE('2016-01-01','YYYY-MM-DD'),'Ciekawa wycieczka ...',3);
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Piękny Kraków','Polska',TO_DATE('2017-02-03','YYYY-MM-DD'),'Najciekawa wycieczka ...',2);
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Wieliczka','Polska',TO_DATE('2017-03-03','YYYY-MM-DD'),'Zadziwiająca kopalnia ...',2);
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Nowy Jork','USA',TO_DATE('2019-03-03','YYYY-MM-DD'),'Świetny wyjazd ...',5);
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Warszawy','USA',TO_DATE('2018-10-13','YYYY-MM-DD'),'Świetny wyjazd ...',5);
--UWAGA
--W razie problemów z formatem daty można użyć funkcji TO_DATE
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Wieliczka2','Polska',TO_DATE('2017-03-03','YYYY-MM-DD'),
 'Zadziwiająca kopalnia ...',2);
INSERT INTO rezerwacje(id_wycieczki, id_osoby, status)
VALUES (1,1,'N');
INSERT INTO rezerwacje(id_wycieczki, id_osoby, status)
VALUES (2,2,'P');
INSERT INTO rezerwacje(id_wycieczki, id_osoby, status)
VALUES (5,2,'P');
INSERT INTO rezerwacje(id_wycieczki, id_osoby, status)
VALUES (5,1,'P');
INSERT INTO rezerwacje(id_wycieczki, id_osoby, status)
VALUES (5,2,'N');
INSERT INTO rezerwacje(id_wycieczki, id_osoby, status)
VALUES (6,2,'N');
-- a) wycieczki_osoby(kraj,data, nazwa_wycieczki, imie, nazwisko,status_rezerwacji)
create view wycieczki_osoby as
  select a.KRAJ, a.DATA, a.NAZWA, c.IMIE, c.NAZWISKO, b.STATUS
  from wycieczki a
         inner join REZERWACJE b on a.ID_WYCIECZKI = b.ID_WYCIECZKI
         inner join OSOBY c on b.ID_OSOBY = c.ID_OSOBY

--b) wycieczki_osoby_potwierdzone (kraj,data, nazwa_wycieczki, imie, nazwisko,status_rezerwacji)
create view wycieczki_osoby_potwierdzone as
  select w.KRAJ, w.DATA, w.nazwa, o.IMIE, o.NAZWISKO, r.STATUS
  from wycieczki w
         inner join REZERWACJE r on w.ID_WYCIECZKI = r.ID_WYCIECZKI
         inner join osoby o on r.ID_OSOBY = o.ID_OSOBY
  where r.STATUS = 'P'

--c) wycieczki_przyszle (kraj,data, nazwa_wycieczki, imie, nazwisko,status_rezerwacji)
create view wycieczki_przyszle as
  select w.KRAJ, w.DATA, w.NAZWA, o.IMIE, o.NAZWISKO, r.STATUS
  from wycieczki w
         inner join REZERWACJE r on w.ID_WYCIECZKI = r.ID_WYCIECZKI
         inner join osoby o on r.ID_OSOBY = o.ID_OSOBY
  where w.DATA > (select CURRENT_DATE from DUAL)

-- d) wycieczki_miejsca(kraj,data, nazwa_wycieczki,liczba_miejsc, liczba_wolnych_miejsc)
create view wycieczki_miejsca as
  select w.KRAJ,
         w.DATA,
         w.NAZWA,
         w.LICZBA_MIEJSC,
         w.LICZBA_MIEJSC -
         NVL((select count(*) from REZERWACJE r where w.ID_WYCIECZKI = r.ID_WYCIECZKI group by r.ID_WYCIECZKI),
             0) as LICZBA_MIEJSC_WOLNYCH
  from WYCIECZKI w

-- e) dostępne_wyciezki(kraj,data, nazwa_wycieczki,liczba_miejsc, liczba_wolnych_miejsc)
create view dostępne_wyciezki as
  select w.KRAJ,
         w.DATA,
         w.NAZWA,
         w.LICZBA_MIEJSC,
         w.LICZBA_MIEJSC -
         NVL((select count(*) from REZERWACJE r where w.ID_WYCIECZKI = r.ID_WYCIECZKI group by r.ID_WYCIECZKI),
             0) as LICZBA_MIEJSC_WOLNYCH
  from WYCIECZKI w
  where w.LICZBA_MIEJSC -
        NVL((select count(*) from REZERWACJE r where w.ID_WYCIECZKI = r.ID_WYCIECZKI group by r.ID_WYCIECZKI),
            0) > 0
    and (select CURRENT_DATE from DUAL) < w.DATA

-- f) rezerwacje_do_ anulowania – lista niepotwierdzonych rezerwacji które powinne zostać anulowane, rezerwacje
create view rezerwacje_do_anulowania as
  select r.NR_REZERWACJI as NR_REZERWACJI_DO_ANULOWANIA
  from REZERWACJE r
         inner join WYCIECZKI w on w.ID_WYCIECZKI = r.ID_WYCIECZKI
  where r.STATUS = 'N'
    and w.DATA - (select CURRENT_DATE from DUAL) < 7
    and w.DATA > (select CURRENT_DATE from DUAL)
-- a) uczestnicy_wycieczki (id_wycieczki), procedura ma zwracać podobny zestaw danych jak
-- widok wycieczki_osoby

create or replace type type_uczestnicy_wycieczki as object (
  id_osoby NUMBER,
  imie     varchar(50),
  nazwisko varchar(50)
);

create or replace type tab_uczestnicy_wycieczki as table of type_uczestnicy_wycieczki;


CREATE OR REPLACE FUNCTION uczestnicy_wycieczki(id IN NUMBER)
  RETURN tab_uczestnicy_wycieczki PIPELINED
AS
  BEGIN
    for x in (SELECT r.id_osoby, o.IMIE, o.NAZWISKO, r.ID_WYCIECZKI
              from REZERWACJE r
                     inner join osoby o on o.ID_OSOBY = r.ID_OSOBY
              where r.ID_WYCIECZKI = id)
    loop
      pipe row (type_uczestnicy_wycieczki(x.id_osoby, x.imie, x.nazwisko));
    end loop;
  END;


CREATE OR REPLACE FUNCTION uczestnicy_wycieczki(id NUMBER)
  RETURN tab_uczestnicy_wycieczki
PIPELINED IS

  BEGIN
    for x in (SELECT r.id_osoby, o.IMIE, o.NAZWISKO
              from REZERWACJE r
                     inner join osoby o on o.ID_OSOBY = r.ID_OSOBY
              where r.ID_WYCIECZKI = id)
    loop
      -- you would usually have a cursor and a loop here
      PIPE ROW (type_uczestnicy_wycieczki(x.id_osoby, x.imie, x.nazwisko));
    end loop;
    RETURN;
  END uczestnicy_wycieczki;



-- b) rezerwacje_osoby(id_osoby), procedura ma zwracać podobny zestaw danych jak widok
-- wycieczki_osoby

create or replace type type_rezerwacje_osoby as object (
  nr_rezerwacji NUMBER
);

create or replace type tab_rezerwacje_osoby as table of type_rezerwacje_osoby;


create or replace function rezerwacje_osoby(id NUMBER)
  return tab_rezerwacje_osoby pipelined
as
  begin
    for x in (select r.NR_REZERWACJI
              from REZERWACJE r
                     inner join OSOBY o on r.ID_OSOBY = o.ID_OSOBY
              where o.ID_OSOBY = id)
    loop
      pipe row (type_rezerwacje_osoby(x.NR_REZERWACJI));
    end loop;
  end;


-- c) przyszle_rezerwacje_osoby(id_osoby)

create or replace function przyszle_rezerwacje_osoby(id NUMBER)
  return tab_rezerwacje_osoby pipelined
as
  begin
    for x in (select r.NR_REZERWACJI
              from REZERWACJE r
                     inner join OSOBY o on r.ID_OSOBY = o.ID_OSOBY
                     inner join wycieczki w on r.ID_WYCIECZKI = w.ID_WYCIECZKI
                   where o.ID_OSOBY = id and w.DATA > (select CURRENT_DATE from dual)
              )
    loop
      pipe row (type_rezerwacje_osoby(x.NR_REZERWACJI));
    end loop;
  end;


-- d) dostepne_wycieczki(kraj, data_od, data_do)

create or replace type type_dostepne_wycieczki as object (
  kraj varchar(50),
  data date
);

create or replace type tab_dostepne_wycieczki as table of type_dostepne_wycieczki;

create or replace function dostepne_wycieczki(kraj varchar2, data_od date, data_do date)
  return tab_dostepne_wycieczki pipelined
as
  begin
    for x in (select w.KRAJ, w.DATA
              from WYCIECZKI w
              where w.LICZBA_MIEJSC -
                    NVL(
                      (select count(*) from REZERWACJE r where w.ID_WYCIECZKI = r.ID_WYCIECZKI group by r.ID_WYCIECZKI),
                      0) > 0
                and ((select CURRENT_DATE from DUAL) < w.DATA)
                and (w.DATA between data_od and data_do)
                and w.KRAJ = kraj)
    loop
      pipe row (type_dostepne_wycieczki(x.KRAJ, x.DATA));
    end loop;
    return;
  end;

-- pomocniczo
create or replace function dostepne_miejsca(id_w NUMBER)
  return NUMBER
is
  liczba_wolnych_miejsc number;
  begin
    select w.LICZBA_MIEJSC -
           NVL((select count(*) from REZERWACJE r where w.ID_WYCIECZKI = r.ID_WYCIECZKI group by r.ID_WYCIECZKI),
               0) into liczba_wolnych_miejsc
    from WYCIECZKI w
    where w.ID_WYCIECZKI = id_w;
    return liczba_wolnych_miejsc;
  end;
-- POMOCNICZO
CREATE OR REPLACE FUNCTION DOSTEPNE_MIEJSCA(ID_W NUMBER)
  RETURN NUMBER
IS
  LICZBA_WOLNYCH_MIEJSC NUMBER;
  BEGIN
    SELECT W.LICZBA_MIEJSC -
           NVL((SELECT COUNT(*) FROM REZERWACJE R WHERE W.ID_WYCIECZKI = R.ID_WYCIECZKI GROUP BY R.ID_WYCIECZKI),
               0) INTO LICZBA_WOLNYCH_MIEJSC
    FROM WYCIECZKI W
    WHERE W.ID_WYCIECZKI = 6;
    RETURN LICZBA_WOLNYCH_MIEJSC;
  END;


-- A) DODAJ_REZERWACJE(ID_WYCIECZKI, ID_OSOBY), PROCEDURA POWINNA KONTROLOWAĆ CZY WYCIECZKA
-- JESZCZE SIĘ NIE ODBYŁA, I CZY SA WOLNE MIEJSCA
CREATE OR REPLACE PROCEDURE DODAJ_REZERWACJE(ID_W NUMBER, ID_O NUMBER)
AS
  BEGIN
    DECLARE
      WYCIECZKI NUMBER;
      OSOBA     NUMBER;
    BEGIN

      SELECT COUNT(W.ID_WYCIECZKI) INTO WYCIECZKI FROM WYCIECZKI W WHERE W.ID_WYCIECZKI = ID_W;
      SELECT O.ID_OSOBY INTO OSOBA FROM OSOBY O WHERE O.ID_OSOBY = ID_O;

      IF WYCIECZKI > 0 AND OSOBA > 0 AND DOSTEPNE_MIEJSCA(ID_W) > 0
      THEN
        INSERT INTO REZERWACJE (ID_WYCIECZKI, ID_OSOBY, STATUS) VALUES (ID_W, ID_O, 'N');
      END IF;

    END;
  END;

-- B) ZMIEN_STATUS_REZERWACJI(ID_REZERWACJI, STATUS), PROCEDURA KONTROLOWAĆ CZY MOŻLIWA JEST
-- ZMIANA STATUSU, NP. ZMIANA STATUSU JUŻ ANULOWANEJ WYCIECZKI (PRZYWRÓCENIE DO STANU
-- AKTYWNEGO NIE ZAWSZE JEST MOŻLIWE)
CREATE OR REPLACE PROCEDURE ZMIEN_STATUS_REZERWACJI(ID_REZERWACJI NUMBER, NEW_STATUS CHAR)
AS
  BEGIN
    DECLARE
      ID_R NUMBER;
      S    CHAR;
    BEGIN
      SELECT COUNT(R.NR_REZERWACJI) INTO ID_R FROM REZERWACJE R WHERE R.NR_REZERWACJI = ID_REZERWACJI;
      SELECT R.STATUS INTO S FROM REZERWACJE R WHERE R.NR_REZERWACJI = ID_REZERWACJI;
      IF ID_R = 1
      THEN
        IF (S <> 'A')
        THEN
          UPDATE REZERWACJE R SET R.STATUS = NEW_STATUS WHERE R.NR_REZERWACJI = ID_REZERWACJI;
        END IF;
      END IF;
    END;
  END;

-- C) ZMIEN_LICZBE_MIEJSC(ID_WYCIECZKI, LICZBA_MIEJSC), NIE WSZYSTKIE ZMIANY LICZBY MIEJSC SĄ
-- DOZWOLONE, NIE MOŻNA ZMNIEJSZYĆ LICZBY MIESC NA WARTOŚĆ PONIŻEJ LICZBY ZAREZERWOWANYCH
-- MIEJSC
CREATE OR REPLACE PROCEDURE ZMIEN_LICZBE_MIEJSC(ID_WYCIECZKI_ NUMBER, NOWA_LICZBA_MIEJSC NUMBER)
AS
  BEGIN
    DECLARE
      CALKOWITA_LICZBA_MIEJSC NUMBER;
      DOSTEPNE_MIEJSCA_ NUMBER;
    BEGIN
      SELECT W.LICZBA_MIEJSC INTO CALKOWITA_LICZBA_MIEJSC FROM WYCIECZKI W WHERE W.ID_WYCIECZKI = ID_WYCIECZKI_;
      SELECT DOSTEPNE_MIEJSCA(ID_WYCIECZKI_) INTO DOSTEPNE_MIEJSCA_ FROM DUAL;
      IF (NOWA_LICZBA_MIEJSC >= (CALKOWITA_LICZBA_MIEJSC - DOSTEPNE_MIEJSCA_))
      THEN
        UPDATE WYCIECZKI W SET W.LICZBA_MIEJSC = NOWA_LICZBA_MIEJSC WHERE W.ID_WYCIECZKI = ID_WYCIECZKI_;
      END IF;
    END;
  END;


-- 6. DODAJEMY TABELĘ DZIENNIKUJĄCĄ ZMIANY STATUSU REZERWACJI
-- REZERWACJE_LOG(ID, ID_REZERWACJI, DATA, STATUS)
-- NALEŻY ZMIENIĆ WARSTWĘ PROCEDUR MODYFIKUJĄCYCH DANE TAK ABY DOPISYWAŁY INFORMACJĘ DO
-- DZIENNIKA
CREATE OR REPLACE PROCEDURE ZMIEN_STATUS_REZERWACJI(ID_REZERWACJI NUMBER, NOWY_STATUS_ CHAR)
AS
  BEGIN
    DECLARE
      ID_R            NUMBER;
      S               CHAR;
      DZISIEJSZA_DATA DATE;
    BEGIN
      SELECT COUNT(R.NR_REZERWACJI) INTO ID_R FROM REZERWACJE R WHERE R.NR_REZERWACJI = ID_REZERWACJI;
      SELECT R.STATUS INTO S FROM REZERWACJE R WHERE R.NR_REZERWACJI = ID_REZERWACJI;
      SELECT CURRENT_DATE INTO DZISIEJSZA_DATA FROM DUAL;
      IF ID_R = 1
      THEN
        IF (S <> 'A') AND NOWY_STATUS_ IN ('N', 'P', 'Z') AND NOWY_STATUS_ <> S
        THEN
          UPDATE REZERWACJE R SET R.STATUS = NOWY_STATUS_ WHERE R.NR_REZERWACJI = ID_REZERWACJI;
          INSERT INTO DZIENNIK_REZERWACJI (NR_REZERWACJI, DATA, NOWY_STATUS)
          VALUES (ID_REZERWACJI, DZISIEJSZA_DATA, NOWY_STATUS_);
        END IF;
      END IF;
    END;
  END;
CREATE TABLE DZIENNIK_REZERWACJI
(
ID_ZMIANY_STATUSU INT GENERATED ALWAYS AS IDENTITY NOT NULL
, NR_REZERWACJI INT
, DATA DATE
, NOWY_STATUS CHAR
, CONSTRAINT DZIENNIK_REZERWACJI_PK PRIMIARY KEY
 (
 ID_ZMIANY_STATUSU
 )
 ENABLE
);

create or replace procedure zmien_status_rezerwacji(id_rezerwacji NUMBER, nowy_status_ char)
as
  begin
    declare
      id_r            NUMBER;
      s               CHAR;
      dzisiejsza_data DATE;
    begin
      select count(r.NR_REZERWACJI) into id_r from REZERWACJE r where r.NR_REZERWACJI = id_rezerwacji;
      select r.status into s from REZERWACJE r where r.NR_REZERWACJI = id_rezerwacji;
      select current_date into dzisiejsza_data from dual;
      if id_r = 1
      then
        if (s <> 'A') and nowy_status_ in ('N', 'P', 'Z') and nowy_status_ <> s
        then
          update REZERWACJE r set r.STATUS = nowy_status_ where r.NR_REZERWACJI = id_rezerwacji;
          INSERT INTO DZIENNIK_REZERWACJI (NR_REZERWACJI, DATA, NOWY_STATUS)
          VALUES (id_rezerwacji, dzisiejsza_data, nowy_status_);
        end if;
      end if;
    end;
  end;
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
-- 8. Zmiana strategii zapisywania do dziennika rezerwacji. Realizacja przy pomocy triggerów
-- Należy wprowadzić zmianę która spowoduje że zapis do dziennika rezerwacji będzie realizowany
-- przy pomocy trigerów
-- triger obsługujący dodanie rezerwacji

CREATE OR REPLACE TRIGGER dodanie_rezerwacji
  AFTER INSERT
  ON REZERWACJE
  FOR EACH ROW
  DECLARE
    aktualna_data date;
  BEGIN
    select current_date into aktualna_data from dual;
    INSERT INTO DZIENNIK_REZERWACJI (NR_REZERWACJI, DATA, NOWY_STATUS)
    VALUES (:new.NR_REZERWACJI, aktualna_data, :new.STATUS);
  END;

-- triger obsługujący zmianę statusu

CREATE OR REPLACE TRIGGER ZMIANA_STATUSU_REZERWACJI
  AFTER UPDATE
  ON REZERWACJE
  FOR EACH ROW
  DECLARE
    AKTUALNA_DATA DATE;
  BEGIN
    SELECT CURRENT_DATE INTO AKTUALNA_DATA FROM DUAL;
    INSERT INTO DZIENNIK_REZERWACJI (NR_REZERWACJI, DATA, NOWY_STATUS)
    VALUES (:NEW.NR_REZERWACJI, AKTUALNA_DATA, :NEW.STATUS);
  END;

-- triger zabraniający usunięcia rezerwacji

CREATE OR REPLACE TRIGGER usuwanie_rezerwacji
  BEFORE DELETE
  ON REZERWACJE
  BEGIN
    raise_application_error(-20001, 'Records can not be deleted');
  END;

create or replace procedure usun_rezerwacje(id_r NUMBER)
as
  begin
    declare
      rezerwacja NUMBER;
    begin
      select count(r.NR_REZERWACJI) into rezerwacja from rezerwacje r where r.NR_REZERWACJI = id_r;

      if rezerwacja = 1
      then
        DELETE FROM rezerwacje r where r.NR_REZERWACJI = id_r;
      end if;
    end;
  end;

-- Oczywiście po wprowadzeniu tej zmiany należy uaktualnić procedury modyfikujące dane.
-- Najlepiej to zrobić tworząc nowe wersje (np. z sufiksem 3)

create procedure zmien_status_rezerwacji_3(id_rezerwacji NUMBER, nowy_status_ char)
as
  begin
    declare
      id_r            NUMBER;
      s               CHAR;
      dzisiejsza_data DATE;
    begin
      select count(r.NR_REZERWACJI) into id_r from REZERWACJE r where r.NR_REZERWACJI = id_rezerwacji;
      select r.status into s from REZERWACJE r where r.NR_REZERWACJI = id_rezerwacji;
      select current_date into dzisiejsza_data from dual;
      if id_r = 1
      then
        if (s <> 'A') and nowy_status_ in ('N', 'P', 'Z') and nowy_status_ <> s
        then
          update REZERWACJE r set r.STATUS = nowy_status_ where r.NR_REZERWACJI = id_rezerwacji;
        end if;
      end if;
    end;
  end;
-- 9. Zmiana strategii obsługi redundantnego pola liczba_wolnych_miejsc . realizacja przy pomocy
-- trigerów
-- triger obsługujący dodanie rezerwacji
create procedure dodaj_rezerwacje_3(id_w NUMBER, id_o NUMBER)
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
      end if;
    end;
  end;

CREATE OR REPLACE TRIGGER dodanie_rezerwacji_3
  AFTER UPDATE
  ON REZERWACJE
  FOR EACH ROW
  DECLARE
    aktualna_data date;
  BEGIN
    select current_date into aktualna_data from dual;
    INSERT INTO DZIENNIK_REZERWACJI (NR_REZERWACJI, DATA, NOWY_STATUS)
    VALUES (:old.NR_REZERWACJI, aktualna_data, :new.STATUS);
    begin
      przelicz;
    end;
  END;

-- triger obsługujący zmianę statusu

-- ten sam co poprzednio

CREATE OR REPLACE TRIGGER zmiana_statusu_rezerwacji
  AFTER UPDATE
  ON REZERWACJE
  FOR EACH ROW
  DECLARE
    aktualna_data date;
  BEGIN
    select current_date into aktualna_data from dual;
    INSERT INTO DZIENNIK_REZERWACJI (NR_REZERWACJI, DATA, NOWY_STATUS)
    VALUES (:old.NR_REZERWACJI, aktualna_data, :new.STATUS);
  END;

-- triger obsługujący zmianę liczby miejsc na poziomie wycieczki
create procedure zmien_liczbe_miejsc_3(id_wycieczki_ NUMBER, nowa_liczba_miejsc NUMBER)
as
  begin
    declare
      calkowita_liczba_miejsc NUMBER;
      dostepne_miejsca_ NUMBER;
    begin
      select w.LICZBA_MIEJSC into calkowita_liczba_miejsc from WYCIECZKI w where w.ID_WYCIECZKI = id_wycieczki_;
      select dostepne_miejsca(id_wycieczki_) into dostepne_miejsca_ from dual;
      if (nowa_liczba_miejsc >= (calkowita_liczba_miejsc - dostepne_miejsca_))
      then
        update WYCIECZKI w set w.LICZBA_MIEJSC = nowa_liczba_miejsc where w.ID_WYCIECZKI = id_wycieczki;
      end if;
    end;
  end;

CREATE OR REPLACE TRIGGER ZMIANA_LICZBY_MIEJSC
  before UPDATE
  ON WYCIECZKI
  FOR EACH ROW
  BEGIN
    declare
      VAL number;
    begin
      VAL := :old.LICZBA_MIEJSC - :old.LICZBA_WOLNYCH_MIEJSC;
      :new.LICZBA_WOLNYCH_MIEJSC := :new.LICZBA_MIEJSC - VAL;
    END;
  end;

-- Oczywiście po wprowadzeniu tej zmiany należy uaktualnić procedury modyfikujące dane.
-- Najlepiej to zrobić tworząc nowe wersje (np. z sufiksem 3)
