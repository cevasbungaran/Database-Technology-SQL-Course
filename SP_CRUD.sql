--SP Insert Peserta
alter procedure insertPeserta
	@idPeserta int,
	@Nama	VARCHAR(512),
    @TanggalLahir	VARCHAR(512),
    @JenisKelamin	VARCHAR(512),
    @AsalKota	VARCHAR(512),
    @Email	VARCHAR(512),
    @NomorHP	VARCHAR(512),
    @StatusPeserta	VARCHAR(512)
as
begin
	INSERT INTO TabelPeserta (IdPeserta, Nama, TanggalLahir, JenisKelamin, AsalKota, Email, NomorHP, StatusPeserta) 
	VALUES (@idPeserta, @Nama, @TanggalLahir, @JenisKelamin, @AsalKota, @Email, @NomorHP, @StatusPeserta)
end

--SP Delete Peserta
ALTER PROCEDURE DeletePeserta
    @statusPeserta varchar(30)
AS
BEGIN
    DELETE FROM TabelPeserta
    WHERE StatusPeserta = @statusPeserta
END

exec DeletePeserta 'Tidak Valid'

--SP Update Email Peserta
ALTER PROCEDURE UpdateEmailPeserta
    @id int,
    @NewEmail VARCHAR(50)
AS
BEGIN
    UPDATE TabelPeserta
    SET Email = @NewEmail
    WHERE IdPeserta = @id
END

--SP Update Nomor Hp Peserta
ALTER PROCEDURE UpdateEmailPeserta
    @id int,
    @NewNum VARCHAR(50)
AS
BEGIN
    UPDATE TabelPeserta
    SET NomorHP = @NewNum
    WHERE IdPeserta = @id
END

exec UpdateEmailPeserta 101, 'wprio17@example.net'

--SP Insert Peserta Lolos
alter procedure InsertPesertaLolos
as
declare
    @temptable table
    (
    nmrPeserta int,
    voteYes int
    )
    insert into @temptable
    select 
        NomorPeserta,
        count(nilai) as voteYes
    from 
        Menilai
    where 
        nilai = 'yes'
    group by 
        NomorPeserta, nilai
    having 
        count (nilai) >= 3

    insert into TabelIdol(idIdol, NomorPeserta)
        select
            ROW_NUMBER() over (order by nmrPeserta) as idIdol,
            nmrPeserta
        from
            @temptable

exec InsertPesertaLolos

--SP Data Peserta Idol
alter procedure DataPesertaIdol
as
select 
	TabelIdol.idIdol, PesertaValid.Nama, Kota.namaKota
from 
	TabelIdol inner join PesertaValid 
on 
	TabelIdol.NomorPeserta = PesertaValid.NomorPeserta inner join Audisi
on 
	Audisi.idAudisi = PesertaValid.IdPeserta inner join Kota
on
	Kota.idKota = Audisi.idKota

exec DataPesertaIdol

--SP Peserta Valid Audisi
alter procedure PesertaValidAudisi
as
select 
	PesertaValid.Nama, Audisi.idAudisi, Audisi.idSeason, Kota.namaKota
from 
	Audisi inner join Kota 
on 
	Audisi.idKota = Kota.idKota inner join PesertaValid 
on 
	Audisi.idAudisi = PesertaValid.IdPeserta

exec PesertaValidAudisi

--SP Insert Member
alter procedure insertMember
	@idMember int,
	@nama varchar(30)
as
begin
	insert into TabelMember (idMember, NamaMember)
	values (@idMember, @nama)
end

exec insertMember 104, 'Jamal'

--SP Delete Member
alter procedure deleteMember
	@idMember int
as
begin
	delete from TabelMember
	where idMember = @idMember
end

exec deleteMember 104

select * from TabelMember

--SP Total Peserta Per Season
alter procedure totalPesertaSeason
as 
begin 
	 select 
		Audisi.idSeason, count(idAudisi) as total
	 from 
		Audisi 
	 group by 
		idSeason
end

exec totalPesertaSeason

--SP Total Peserta Audisi Per Kota
alter procedure totalPesertaAudisi
as 
begin 
	select 
		Kota.namaKota, count(idAudisi) as totalPeserta
	from 
		Audisi inner join Kota
	on
		Audisi.idKota = Kota.idKota
	group by 
		Kota.namaKota
end

exec totalPesertaAudisi






