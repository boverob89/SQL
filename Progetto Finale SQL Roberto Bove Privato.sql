-- Usato Drop su ogni tabella temporanea per eliminare la tabella esistente e rilanciare il file 
-- tutte le volte che si desidera 
DROP TEMPORARY TABLE IF EXISTS Temp_Clienti; 
-- Creazione della tabella temporanea per i clienti con calcolo età
CREATE TEMPORARY TABLE Temp_Clienti AS
SELECT 
    c.*, 
    FLOOR(DATEDIFF(CURRENT_DATE(), c.data_nascita) / 365) AS eta
FROM banca.cliente c;

-- Creazione della tabella temporanea per numero e importo transazioni in entrata e uscita 
DROP TEMPORARY TABLE IF EXISTS Temp_Transazioni;
CREATE TEMPORARY TABLE Temp_Transazioni AS
SELECT 
    c.id_cliente,
    ******(CASE WHEN ********* = '+' THEN ********* ELSE 0 END) AS NumTransazioniEntrata,
    ******(CASE WHEN ********* = '-' THEN ********* ELSE 0 END) AS NumTransazioniUscita,
    ******(CASE WHEN ********* = '+' THEN ********* ELSE 0 END) AS ImportoTotaleEntrata,
    ******(CASE WHEN ********* = '-' THEN ********* ELSE 0 END) AS ImportoTotaleUscita
FROM banca.transazioni tr
LEFT JOIN banca.tipo_transazione ttr ON tr.id_tipo_trans = ttr.id_tipo_transazione
LEFT JOIN banca.conto c ON tr.id_conto = c.id_conto
GROUP BY c.id_cliente;

-- Creazione della tabella temporanea per il conteggio tipologia dei conti per cliente
DROP TEMPORARY TABLE IF EXISTS Temp_Conti;
CREATE TEMPORARY TABLE Temp_Conti AS
SELECT 
    c.id_cliente,
    ******(*) AS Totale_conti,
    ******(CASE WHEN ********* = '0' THEN ********* ELSE 0 END) AS Conto_base,
    ******(CASE WHEN ********* = '1' THEN ********* ELSE 0 END) AS Conto_business,
    ******(CASE WHEN ********* = '2' THEN ********* ELSE 0 END) AS Conto_privato,
    ******(CASE WHEN ********* = '3' THEN ********* ELSE 0 END) AS Conto_famiglie
FROM banca.conto c
LEFT JOIN banca.tipo_conto tc ON c.id_tipo_conto = tc.id_tipo_conto
GROUP BY c.id_cliente;

-- Creazione della tabella temporanea per le transazioni per tipologia di conto per cliente
DROP TEMPORARY TABLE IF EXISTS Temp_Transazioni_Conto;
CREATE TEMPORARY TABLE Temp_Transazioni_Conto AS
SELECT 
    c.id_cliente,
    -- Numero transazioni in entrata per tipologia conto
    ******(CASE WHEN ********* = '0' AND ********* = '+' THEN 1 ELSE 0 END) AS Num_TrEntrata_ContoBase,
    ******(CASE WHEN ********* = '1' AND ********* = '+' THEN 1 ELSE 0 END) AS Num_TrEntrata_ContoBusiness,
    ******(CASE WHEN ********* = '2' AND ********* = '+' THEN 1 ELSE 0 END) AS Num_TrEntrata_ContoPrivati,
    ******(CASE WHEN ********* = '3' AND ********* = '+' THEN 1 ELSE 0 END) AS Num_TrEntrata_ContoFamiglie,

    -- Numero transazioni in uscita per tipologia conto
    ******(CASE WHEN ********* = '0' AND ********* = '-' THEN 1 ELSE 0 END) AS Num_TrUscita_ContoBase,
    ******(CASE WHEN ********* = '1' AND ********* = '-' THEN 1 ELSE 0 END) AS Num_TrUscita_ContoBusiness,
    ******(CASE WHEN ********* = '2' AND ********* = '-' THEN 1 ELSE 0 END) AS Num_TrUscita_ContoPrivati,
    ******(CASE WHEN ********* = '3' AND ********* = '-' THEN 1 ELSE 0 END) AS Num_TrUscita_ContoFamiglie,

    -- Totale importo transato in entrata per tipologia conto
    ******(CASE WHEN ********* = '0' AND ********* = '+' THEN ********* ELSE 0 END) AS Tot_TrEntrata_ContoBase,
    ******(CASE WHEN ********* = '1' AND ********* = '+' THEN ********* ELSE 0 END) AS Tot_TrEntrata_ContoBusiness,
    ******(CASE WHEN ********* = '2' AND ********* = '+' THEN ********* ELSE 0 END) AS Tot_TrEntrata_ContoPrivati,
    ******(CASE WHEN ********* = '3' AND ********* = '+' THEN ********* ELSE 0 END) AS Tot_TrEntrata_ContoFamiglie,

    -- Totale importo transato in uscita per tipologia conto
    ******(CASE WHEN ********* = '0' AND ********* = '-' THEN ********* ELSE 0 END) AS Tot_TrUscita_ContoBase,
    ******(CASE WHEN ********* = '1' AND ********* = '-' THEN ********* ELSE 0 END) AS Tot_TrUscita_ContoBusiness,
    ******(CASE WHEN ********* = '2' AND ********* = '-' THEN ********* ELSE 0 END) AS Tot_TrUscita_ContoPrivati,
    ******(CASE WHEN ********* = '3' AND ********* = '-' THEN ********* ELSE 0 END) AS Tot_TrUscita_ContoFamiglie
FROM banca.transazioni tr
LEFT JOIN banca.conto c ON tr.id_conto = c.id_conto
LEFT JOIN banca.tipo_transazione ttr ON tr.id_tipo_trans = ttr.id_tipo_transazione
GROUP BY c.id_cliente;


SELECT 
    tc.id_cliente, eta, -- id cliente e eta 
    ttr.NumTransazioniEntrata, -- ttr = temp transazioni
    ttr.NumTransazioniUscita, 
	******(ttr.ImportoTotaleEntrata, 2) AS ImportoTotaleEntrata, -- funzione ****** per ridurre i decimali 
    ******(ttr.ImportoTotaleUscita, 2) AS ImportoTotaleUscita,   -- sul totale per renderlo più leggibile
    tco.Totale_conti, -- tco = temp conti
    tco.Conto_base, 
    tco.Conto_business, 
    tco.Conto_privato, 
    tco.Conto_famiglie,
    ttc.Num_TrEntrata_ContoBase, -- ttc = temp transazioni conto
    ttc.Num_TrUscita_ContoBase, 
    ttc.Num_TrEntrata_ContoBusiness,
    ttc.Num_TrUscita_ContoBusiness,
    ttc.Num_TrEntrata_ContoPrivati, 
    ttc.Num_TrUscita_ContoPrivati,
    ttc.Num_TrEntrata_ContoFamiglie,
    ttc.Num_TrUscita_ContoFamiglie,
    ******(ttc.Tot_TrEntrata_ContoBase, 2) AS Tot_TrEntrata_ContoBase, -- funzione ****** per ridurre i decimali 
    ******(ttc.Tot_TrUscita_ContoBase, 2) AS Tot_TrUscita_ContoBase,   -- sul totale per renderlo più leggibile
    ******(ttc.Tot_TrEntrata_ContoBusiness, 2) AS Tot_TrEntrata_ContoBusiness,
    ******(ttc.Tot_TrUscita_ContoBusiness, 2) AS Tot_TrUscita_ContoBusiness, 
    ******(ttc.Tot_TrEntrata_ContoPrivati, 2) AS Tot_TrEntrata_ContoPrivati,
    ******(ttc.Tot_TrUscita_ContoPrivati, 2) AS Tot_TrUscita_ContoPrivati, 
    ******(ttc.Tot_TrEntrata_ContoFamiglie, 2) AS Tot_TrEntrata_ContoFamiglie,
    ******(ttc.Tot_TrUscita_ContoFamiglie, 2) AS Tot_TrUscita_ContoFamiglie
        
FROM Temp_Clienti tc
LEFT JOIN Temp_Transazioni ttr ON tc.id_cliente = ttr.id_cliente
LEFT JOIN Temp_Conti tco ON tc.id_cliente = tco.id_cliente
LEFT JOIN Temp_Transazioni_Conto ttc ON tc.id_cliente = ttc.id_cliente
