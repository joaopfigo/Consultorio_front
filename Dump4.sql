-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: terapia_corporal
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `agendamentos`
--

DROP TABLE IF EXISTS `agendamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agendamentos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) DEFAULT NULL,
  `nome_visitante` varchar(100) DEFAULT NULL,
  `email_visitante` varchar(100) DEFAULT NULL,
  `telefone_visitante` varchar(20) DEFAULT NULL,
  `idade_visitante` int(11) DEFAULT NULL,
  `especialidade_id` int(11) DEFAULT NULL,
  `data_horario` datetime NOT NULL,
  `duracao` int(11) NOT NULL,
  `adicional_reflexo` tinyint(1) DEFAULT 0,
  `status` varchar(20) DEFAULT 'Pendente',
  `criado_em` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_usuario` (`usuario_id`),
  KEY `fk_servico` (`especialidade_id`),
  CONSTRAINT `fk_servico` FOREIGN KEY (`especialidade_id`) REFERENCES `especialidades` (`id`),
  CONSTRAINT `fk_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agendamentos`
--

LOCK TABLES `agendamentos` WRITE;
/*!40000 ALTER TABLE `agendamentos` DISABLE KEYS */;
/*!40000 ALTER TABLE `agendamentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `anamneses`
--

DROP TABLE IF EXISTS `anamneses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `anamneses` (
  `agendamento_id` int(11) NOT NULL,
  `resumo` text NOT NULL,
  `orientacoes` text DEFAULT NULL,
  `data_escrita` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`agendamento_id`),
  CONSTRAINT `fk_agendamento_anamn` FOREIGN KEY (`agendamento_id`) REFERENCES `agendamentos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `anamneses`
--

LOCK TABLES `anamneses` WRITE;
/*!40000 ALTER TABLE `anamneses` DISABLE KEYS */;
/*!40000 ALTER TABLE `anamneses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `consulta`
--

DROP TABLE IF EXISTS `consulta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consulta` (
  `idConsulta` int(11) NOT NULL AUTO_INCREMENT,
  `idPaciente` int(11) NOT NULL,
  `idTerapeuta` int(11) NOT NULL,
  `data` date NOT NULL,
  `hora` time NOT NULL,
  `status` enum('pendente','confirmada','cancelada') NOT NULL DEFAULT 'pendente',
  PRIMARY KEY (`idConsulta`),
  KEY `idPaciente` (`idPaciente`),
  KEY `idTerapeuta` (`idTerapeuta`),
  CONSTRAINT `consulta_ibfk_1` FOREIGN KEY (`idPaciente`) REFERENCES `paciente` (`idPaciente`),
  CONSTRAINT `consulta_ibfk_2` FOREIGN KEY (`idTerapeuta`) REFERENCES `terapeuta` (`idTerapeuta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consulta`
--

LOCK TABLES `consulta` WRITE;
/*!40000 ALTER TABLE `consulta` DISABLE KEYS */;
/*!40000 ALTER TABLE `consulta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contatos`
--

DROP TABLE IF EXISTS `contatos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contatos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `mensagem` text NOT NULL,
  `recebido_em` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contatos`
--

LOCK TABLES `contatos` WRITE;
/*!40000 ALTER TABLE `contatos` DISABLE KEYS */;
/*!40000 ALTER TABLE `contatos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `especialidade`
--

DROP TABLE IF EXISTS `especialidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `especialidade` (
  `idEspecialidade` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  PRIMARY KEY (`idEspecialidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `especialidade`
--

LOCK TABLES `especialidade` WRITE;
/*!40000 ALTER TABLE `especialidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `especialidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `especialidades`
--

DROP TABLE IF EXISTS `especialidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `especialidades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `descricao` text DEFAULT NULL,
  `ativa` tinyint(1) DEFAULT 1,
  `quick` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `especialidades`
--

LOCK TABLES `especialidades` WRITE;
/*!40000 ALTER TABLE `especialidades` DISABLE KEYS */;
INSERT INTO `especialidades` VALUES (1,'Quick Massage','Massagem rápida',1,1),(2,'Massoterapia','Massagem terapêutica',1,0),(3,'Reflexologia Podal','Massagem nos pés',1,0),(4,'Auriculoterapia','Terapia na orelha',1,0),(5,'Ventosa','Terapia com ventosas',1,0),(6,'Acupuntura','Terapia com agulhas',1,0),(7,'Biomagnetismo','Terapia com ímãs',1,0),(8,'Reiki','Energia vital',1,0);
/*!40000 ALTER TABLE `especialidades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `formularioqueixa`
--

DROP TABLE IF EXISTS `formularioqueixa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formularioqueixa` (
  `idQueixa` int(11) NOT NULL AUTO_INCREMENT,
  `idConsulta` int(11) NOT NULL,
  `sintomas` text DEFAULT NULL,
  `tempoDor` varchar(50) DEFAULT NULL,
  `intensidade` tinyint(4) DEFAULT NULL,
  `tratamentoAnterior` text DEFAULT NULL,
  PRIMARY KEY (`idQueixa`),
  KEY `idConsulta` (`idConsulta`),
  CONSTRAINT `formularioqueixa_ibfk_1` FOREIGN KEY (`idConsulta`) REFERENCES `consulta` (`idConsulta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formularioqueixa`
--

LOCK TABLES `formularioqueixa` WRITE;
/*!40000 ALTER TABLE `formularioqueixa` DISABLE KEYS */;
/*!40000 ALTER TABLE `formularioqueixa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `formularios_queixa`
--

DROP TABLE IF EXISTS `formularios_queixa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `formularios_queixa` (
  `agendamento_id` int(11) NOT NULL,
  `desconforto_principal` text DEFAULT NULL,
  `queixa_secundaria` text DEFAULT NULL,
  `tempo_desconforto` varchar(100) DEFAULT NULL,
  `classificacao_dor` varchar(50) DEFAULT NULL,
  `tratamento_medico` text DEFAULT NULL,
  `em_cuidados_medicos` tinyint(1) DEFAULT NULL,
  `medicacao` tinyint(1) DEFAULT NULL,
  `gravida` tinyint(1) DEFAULT NULL,
  `lesao` tinyint(1) DEFAULT NULL,
  `torcicolo` tinyint(1) DEFAULT NULL,
  `dor_coluna` tinyint(1) DEFAULT NULL,
  `caimbras` tinyint(1) DEFAULT NULL,
  `distensoes` tinyint(1) DEFAULT NULL,
  `fraturas` tinyint(1) DEFAULT NULL,
  `edemas` tinyint(1) DEFAULT NULL,
  `outras_dores` tinyint(1) DEFAULT NULL,
  `cirurgias` tinyint(1) DEFAULT NULL,
  `prob_pele` tinyint(1) DEFAULT NULL,
  `digestivo` tinyint(1) DEFAULT NULL,
  `intestino` tinyint(1) DEFAULT NULL,
  `prisao_ventre` tinyint(1) DEFAULT NULL,
  `circulacao` tinyint(1) DEFAULT NULL,
  `trombose` tinyint(1) DEFAULT NULL,
  `cardiaco` tinyint(1) DEFAULT NULL,
  `pressao` tinyint(1) DEFAULT NULL,
  `artrite` tinyint(1) DEFAULT NULL,
  `asma` tinyint(1) DEFAULT NULL,
  `alergia` tinyint(1) DEFAULT NULL,
  `rinite` tinyint(1) DEFAULT NULL,
  `diabetes` tinyint(1) DEFAULT NULL,
  `colesterol` tinyint(1) DEFAULT NULL,
  `epilepsia` tinyint(1) DEFAULT NULL,
  `osteoporose` tinyint(1) DEFAULT NULL,
  `cancer` tinyint(1) DEFAULT NULL,
  `contagiosa` tinyint(1) DEFAULT NULL,
  `sono` tinyint(1) DEFAULT NULL,
  `ansiedade` tinyint(1) DEFAULT NULL,
  `tristeza` tinyint(1) DEFAULT NULL,
  `raiva` tinyint(1) DEFAULT NULL,
  `preocupacao` tinyint(1) DEFAULT NULL,
  `medo` tinyint(1) DEFAULT NULL,
  `irritacao` tinyint(1) DEFAULT NULL,
  `angustia` tinyint(1) DEFAULT NULL,
  `termo_aceite` tinyint(1) NOT NULL,
  PRIMARY KEY (`agendamento_id`),
  CONSTRAINT `fk_agendamento` FOREIGN KEY (`agendamento_id`) REFERENCES `agendamentos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formularios_queixa`
--

LOCK TABLES `formularios_queixa` WRITE;
/*!40000 ALTER TABLE `formularios_queixa` DISABLE KEYS */;
/*!40000 ALTER TABLE `formularios_queixa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paciente`
--

DROP TABLE IF EXISTS `paciente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paciente` (
  `idPaciente` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cpf` char(11) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idPaciente`),
  UNIQUE KEY `cpf` (`cpf`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paciente`
--

LOCK TABLES `paciente` WRITE;
/*!40000 ALTER TABLE `paciente` DISABLE KEYS */;
/*!40000 ALTER TABLE `paciente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pacotes`
--

DROP TABLE IF EXISTS `pacotes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pacotes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) NOT NULL,
  `total_sessoes` int(11) NOT NULL,
  `sessoes_usadas` int(11) DEFAULT 0,
  `criado_em` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `pacotes_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pacotes`
--

LOCK TABLES `pacotes` WRITE;
/*!40000 ALTER TABLE `pacotes` DISABLE KEYS */;
INSERT INTO `pacotes` VALUES (1,1,5,0,'2025-06-01 20:19:52');
/*!40000 ALTER TABLE `pacotes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `terapeuta`
--

DROP TABLE IF EXISTS `terapeuta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `terapeuta` (
  `idTerapeuta` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `idEspecialidade` int(11) NOT NULL,
  PRIMARY KEY (`idTerapeuta`),
  KEY `idEspecialidade` (`idEspecialidade`),
  CONSTRAINT `terapeuta_ibfk_1` FOREIGN KEY (`idEspecialidade`) REFERENCES `especialidade` (`idEspecialidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `terapeuta`
--

LOCK TABLES `terapeuta` WRITE;
/*!40000 ALTER TABLE `terapeuta` DISABLE KEYS */;
/*!40000 ALTER TABLE `terapeuta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `nascimento` date DEFAULT NULL,
  `idade` int(11) DEFAULT NULL,
  `senha_hash` varchar(255) NOT NULL,
  `foto_perfil` varchar(255) DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT 0,
  `criado_em` datetime DEFAULT current_timestamp(),
  `sexo` varchar(20) DEFAULT NULL,
  `token_recuperacao` varchar(100) DEFAULT NULL,
  `token_expira` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'teste1','joaopedrofvalle@gmail.com','+5531999654279',NULL,NULL,'$2y$10$NyDTrSZQ86KkDFZcKJ0AeOoOCdLEZPdimJep9NzJvsyJLYiIQp8x.',NULL,0,'2025-05-28 13:31:15',NULL,NULL,NULL),(2,'João Pedro Figueiredo','joao.valle@sga.pucminas.br','+5531999654279',NULL,20,'$2y$10$CaSLA648TC4BBFig4QRop.0M83dnrmFDVeuqCpvGuJpZbC2BRjpi2',NULL,0,'2025-05-28 14:23:53','masculino','dbe249a0f2390845fcf8f483f119a9394075b6726a44114f9c850c036a39','2025-06-01 00:02:59'),(3,'','',NULL,NULL,NULL,'$2y$10$P1KSgTbcv5Du/UN70x4kqOCofh4AhetVGSDI3tMij9uXFsxkQ3Mm.','uploads/perfil_3_1748546146.png',0,'2025-05-29 10:08:45',NULL,NULL,NULL),(4,'teste3','joao.pedro@gbv.g12.br','+55319996542790',NULL,20,'$2y$10$985YpngkPSQytEMWZibVaOkFlai5FQ972ZUvVVT8CmuRFLIJWZ5E.','uploads/perfil_4_1748547204.png',0,'2025-05-29 16:28:01','Masculino',NULL,NULL),(5,'Lara Melo Ruas','laramrrf@gmail.com','31999544558','0000-00-00',24,'$2y$10$ellkIWh.KKkFEjHGFL/hweTfysMt3mXd.dqsA6WutYYN5ioKCVdOm','uploads/perfil_5_1748557925.png',0,'2025-05-29 17:59:56','Feminino','7e5216c07348db6e290df08e5275ec69fdb3c19768f33888dff1338c6121','2025-06-01 01:39:06'),(6,'João Teste','joao@teste.com',NULL,NULL,NULL,'$2y$10$V2IXO8QbRxFQ.MpRh.x5Y.S5Ojf0H8Agi3USbduqv8jqw4F9xHR4y',NULL,0,'2025-05-30 15:48:02',NULL,NULL,NULL);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'terapia_corporal'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-01 23:27:44
