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

create or replace trigger zmiana_liczby_miejsc
  after update
  on wycieczki
  for each row
  when (new.LICZBA_MIEJSC >= 0)
  begin
    PRZELICZ();
  end;
-- Oczywiście po wprowadzeniu tej zmiany należy uaktualnić procedury modyfikujące dane.
-- Najlepiej to zrobić tworząc nowe wersje (np. z sufiksem 3)
