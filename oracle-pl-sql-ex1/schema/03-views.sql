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