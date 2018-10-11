-- 5. Tworzenie procedur modyfikujących dane. Należy przygotować zestaw procedur pozwalających
-- na modyfikację danych oraz kontrolę poprawności ich wprowadzania
-- a) dodaj_rezerwacje(id_wycieczki, id_osoby), procedura powinna kontrolować czy wycieczka
-- jeszcze się nie odbyła, i czy sa wolne miejsca
create or replace procedure dodaj_rezerwacje(id_w NUMBER, id_o NUMBER)
as
  begin
    if ((select w.id_wycieczki from WYCIECZKI w where w.ID_WYCIECZKI = id_w) is not null
        and
        (select o.id_osoby from OSOBY o where o.id_osoby = id_o) is not null)
    begin
      INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
      VALUES (id_w, id_o, 'N');
    end
  end;



-- b) zmien_status_rezerwacji(id_rezerwacji, status), procedura kontrolować czy możliwa jest
-- zmiana statusu, np. zmiana statusu już anulowanej wycieczki (przywrócenie do stanu
-- aktywnego nie zawsze jest możliwe)


-- c) zmien_liczbe_miejsc(id_wycieczki, liczba_miejsc), nie wszystkie zmiany liczby miejsc są
-- dozwolone, nie można zmniejszyć liczby miesc na wartość poniżej liczby zarezerwowanych
-- miejsc


-- Należy rozważyć użycie transakcji
-- Należy zwrócić uwagę na kontrolę parametrów (np. jeśli parametrem jest id_wycieczki to należy
-- sprawdzić czy taka wycieczka istnieje, jeśli robimy rezerwację to należy sprawdzać czy są wolne
-- miejsca)

CREATE OR REPLACE
PROCEDURE ADD_EVALUATION
  (   evaluation_id   IN NUMBER
    , employee_id     IN NUMBER
    , evaluation_date IN DATE
    , job_id          IN VARCHAR2
    , manager_id      IN NUMBER
    , department_id   IN NUMBER
  ) AS
  BEGIN
    NULL;
  END ADD_EVALUATION;
