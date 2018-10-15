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
    where w.ID_WYCIECZKI = 6;
    return liczba_wolnych_miejsc;
  end;


-- a) dodaj_rezerwacje(id_wycieczki, id_osoby), procedura powinna kontrolować czy wycieczka
-- jeszcze się nie odbyła, i czy sa wolne miejsca
create or replace procedure dodaj_rezerwacje(id_w NUMBER, id_o NUMBER)
as
  begin
    declare
      wycieczki NUMBER;
      osoba     NUMBER;
    begin

      select count(w.id_wycieczki) into wycieczki from WYCIECZKI w where w.ID_WYCIECZKI = id_w;
      select o.id_osoby into osoba from OSOBY o where o.id_osoby = id_o;

      if wycieczki > 0 and osoba > 0 and dostepne_miejsca(id_w) > 0
      then
        INSERT INTO rezerwacje (id_wycieczki, id_osoby, status) VALUES (id_w, id_o, 'N');
      end if;

    end;
  end;

-- b) zmien_status_rezerwacji(id_rezerwacji, status), procedura kontrolować czy możliwa jest
-- zmiana statusu, np. zmiana statusu już anulowanej wycieczki (przywrócenie do stanu
-- aktywnego nie zawsze jest możliwe)
create or replace procedure zmien_status_rezerwacji(id_rezerwacji NUMBER, new_status char)
as
  begin
    declare
      id_r NUMBER;
      s    CHAR;
    begin
      select count(r.NR_REZERWACJI) into id_r from REZERWACJE r where r.NR_REZERWACJI = id_rezerwacji;
      select r.status into s from REZERWACJE r where r.NR_REZERWACJI = id_rezerwacji;
      if id_r = 1
      then
        if (s <> 'A')
        then
          update REZERWACJE r set r.STATUS = new_status where r.NR_REZERWACJI = id_rezerwacji;
        end if;
      end if;
    end;
  end;

-- c) zmien_liczbe_miejsc(id_wycieczki, liczba_miejsc), nie wszystkie zmiany liczby miejsc są
-- dozwolone, nie można zmniejszyć liczby miesc na wartość poniżej liczby zarezerwowanych
-- miejsc
create or replace procedure zmien_liczbe_miejsc(id_wycieczki_ NUMBER, nowa_liczba_miejsc NUMBER)
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
        update WYCIECZKI w set w.LICZBA_MIEJSC = nowa_liczba_miejsc where w.ID_WYCIECZKI = id_wycieczki_;
      end if;
    end;
  end;


-- 6. Dodajemy tabelę dziennikującą zmiany statusu rezerwacji
-- rezerwacje_log(id, id_rezerwacji, data, status)
-- Należy zmienić warstwę procedur modyfikujących dane tak aby dopisywały informację do
-- dziennika
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
