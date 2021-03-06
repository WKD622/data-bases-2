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
