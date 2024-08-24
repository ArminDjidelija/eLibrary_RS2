//using Microsoft.EntityFrameworkCore;
//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using System.Threading.Tasks;

//namespace eLibrary.Services.Database
//{
//    partial class ELibraryContext : DbContext
//    {
//        partial void OnModelCreatingPartial(ModelBuilder modelBuilder)
//        {
//            modelBuilder.Entity<Database.Autori>().HasData(
//        new Database.Autori { AutorId = 1, Ime = "Leo", Prezime = "Tolstoy", GodinaRodjenja = 1828 },
//        new Database.Autori { AutorId = 2, Ime = "Ernest", Prezime = "Hemingway", GodinaRodjenja = 1899 },
//        new Database.Autori { AutorId = 3, Ime = "Franz", Prezime = "Kafka", GodinaRodjenja = 1883 },
//        new Database.Autori { AutorId = 4, Ime = "Sergey", Prezime = "Yesenin", GodinaRodjenja = 1895 },
//        new Database.Autori { AutorId = 5, Ime = "Alexander", Prezime = "Pushkin", GodinaRodjenja = 1799 },
//        new Database.Autori { AutorId = 6, Ime = "Fjodor", Prezime = "Dostojevski", GodinaRodjenja = 1821 },
//        new Database.Autori { AutorId = 7, Ime = "George", Prezime = "Orwell", GodinaRodjenja = 1903 },
//        new Database.Autori { AutorId = 8, Ime = "Mark", Prezime = "Twain", GodinaRodjenja = 1835 },
//        new Database.Autori { AutorId = 9, Ime = "Charles", Prezime = "Dickens", GodinaRodjenja = 1845 }
//            );

//            modelBuilder.Entity<Database.CiljneGrupe>().HasData(
//       new Database.CiljneGrupe { CiljnaGrupaId = 1, Naziv = "Odrasli >18" },
//       new Database.CiljneGrupe { CiljnaGrupaId = 2, Naziv = "Djeca" },
//       new Database.CiljneGrupe { CiljnaGrupaId = 3, Naziv = "Ozbiljna" },
//       new Database.CiljneGrupe { CiljnaGrupaId = 4, Naziv = "10-14" },
//       new Database.CiljneGrupe { CiljnaGrupaId = 5, Naziv = "14-18" },
//       new Database.CiljneGrupe { CiljnaGrupaId = 6, Naziv = "Opšte štivo" }
//            );
//            modelBuilder.Entity<Database.Kantoni>().HasData(
//        new Database.Kantoni { KantonId = 1, Naziv = "Unsko-sanski kanton", Skracenica = "USK" },
//        new Database.Kantoni { KantonId = 2, Naziv = "Posavski kanton", Skracenica = "PK" },
//        new Database.Kantoni { KantonId = 3, Naziv = "Tuzlanski kanton", Skracenica = "TK" },
//        new Database.Kantoni { KantonId = 4, Naziv = "Zenicko-dobojski kanton", Skracenica = "ZDK" },
//        new Database.Kantoni { KantonId = 5, Naziv = "Bosansko-podrinjski kanton Goražde", Skracenica = "BPK" },
//        new Database.Kantoni { KantonId = 6, Naziv = "Srednjobosanski kanton", Skracenica = "SBK" },
//        new Database.Kantoni { KantonId = 7, Naziv = "Hercegovacko-neretvanski kanton", Skracenica = "HNK" },
//        new Database.Kantoni { KantonId = 8, Naziv = "Zapadnohercegovacki kanton", Skracenica = "ZHK" },
//        new Database.Kantoni { KantonId = 9, Naziv = "Kanton Sarajevo", Skracenica = "KS" },
//        new Database.Kantoni { KantonId = 10, Naziv = "Kanton 10", Skracenica = "K10" }
//            );

//            modelBuilder.Entity<Database.VrsteSadrzaja>().HasData(
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 1, Naziv = "Roman" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 2, Naziv = "Poezija" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 3, Naziv = "Fantastika" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 4, Naziv = "Putopis" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 5, Naziv = "Kriminalistika" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 6, Naziv = "Ljubavni roman" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 7, Naziv = "Triler" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 8, Naziv = "Vestern" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 9, Naziv = "Modernizam" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 10, Naziv = "Pustolovni roman" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 11, Naziv = "Naucna fantastika" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 12, Naziv = "Doktorski rad" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 13, Naziv = "Diplomski rad" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 14, Naziv = "Magistarski rad" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 15, Naziv = "Stručni rad" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 16, Naziv = "Udžbenik" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 17, Naziv = "Tehnički izvještaj" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 18, Naziv = "Zbornik" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 19, Naziv = "Rječnik" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 21, Naziv = "Istraživački rad" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 22, Naziv = "Enciklopedija" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 23, Naziv = "Biografija" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 24, Naziv = "Književnost" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 25, Naziv = "Bajka" },
//    new Database.VrsteSadrzaja { VrstaSadrzajaId = 26, Naziv = "Dječije knjige" }
//            );

//            modelBuilder.Entity<Database.VrsteGrade>().HasData(
//    new Database.VrsteGrade { VrstaGradeId = 1, Naziv = "Knjiga" },
//    new Database.VrsteGrade { VrstaGradeId = 3, Naziv = "Časopis" },
//    new Database.VrsteGrade { VrstaGradeId = 4, Naziv = "E-Knjiga" },
//    new Database.VrsteGrade { VrstaGradeId = 5, Naziv = "Audio knjiga" },
//    new Database.VrsteGrade { VrstaGradeId = 6, Naziv = "Članak" }
//            );

//            modelBuilder.Entity<Database.Valute>().HasData(
//    new Database.Valute { ValutaId = 1, Naziv = "Konvertibilna marka", Skracenica = "KM" },
//    new Database.Valute { ValutaId = 2, Naziv = "Euro", Skracenica = "EUR" }
//            );

//            modelBuilder.Entity<Database.Uvezi>().HasData(
//    new Database.Uvezi { UvezId = 1, Naziv = "Mehki" },
//    new Database.Uvezi { UvezId = 2, Naziv = "Tvrdi" },
//    new Database.Uvezi { UvezId = 5, Naziv = "Bez uveza" }
//            );

//            modelBuilder.Entity<Database.Uloge>().HasData(
//    new Database.Uloge { UlogaId = 1, Naziv = "Bibliotekar" },
//    new Database.Uloge { UlogaId = 2, Naziv = "Administrator" },
//    new Database.Uloge { UlogaId = 3, Naziv = "Menadzer" }
//            );

//            modelBuilder.Entity<Database.TipoviUplatum>().HasData(
//    new Database.TipoviUplatum { TipUplateId = 1, Naziv = "Online" },
//    new Database.TipoviUplatum { TipUplateId = 2, Naziv = "Keš" }
//            );

//            modelBuilder.Entity<Database.Jezici>().HasData(
//    new Database.Jezici { JezikId = 1, Naziv = "Bosanski" },
//    new Database.Jezici { JezikId = 2, Naziv = "Hrvatski" },
//    new Database.Jezici { JezikId = 3, Naziv = "Srpski" },
//    new Database.Jezici { JezikId = 4, Naziv = "Engleski" },
//    new Database.Jezici { JezikId = 5, Naziv = "Crnogorski" },
//    new Database.Jezici { JezikId = 6, Naziv = "Njemački" },
//    new Database.Jezici { JezikId = 7, Naziv = "Španski" },
//    new Database.Jezici { JezikId = 8, Naziv = "Francuski" },
//    new Database.Jezici { JezikId = 9, Naziv = "Ruski" },
//    new Database.Jezici { JezikId = 10, Naziv = "Slovenski" },
//    new Database.Jezici { JezikId = 11, Naziv = "Indijski" }
//            );

//            modelBuilder.Entity<Database.Izdavaci>().HasData(
//    new Database.Izdavaci { IzdavacId = 1, Naziv = "BH Most" },
//    new Database.Izdavaci { IzdavacId = 2, Naziv = "Globus Media" },
//    new Database.Izdavaci { IzdavacId = 3, Naziv = "Laguna" },
//    new Database.Izdavaci { IzdavacId = 4, Naziv = "Plato" },
//    new Database.Izdavaci { IzdavacId = 5, Naziv = "Nova knjiga, Kosmos" },
//    new Database.Izdavaci { IzdavacId = 6, Naziv = "Rabic" },
//    new Database.Izdavaci { IzdavacId = 7, Naziv = "Otvorena knjiga" },
//    new Database.Izdavaci { IzdavacId = 9, Naziv = "Školska knjiga" }
//            );

//        }
//    }
//}
