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
