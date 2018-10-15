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
