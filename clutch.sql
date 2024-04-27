<<<<<<< HEAD
-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.32-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para clutch
CREATE DATABASE IF NOT EXISTS `clutch` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `clutch`;

-- Copiando estrutura para tabela clutch.accounts
CREATE TABLE IF NOT EXISTS `accounts` (
  `steam` varchar(50) NOT NULL DEFAULT '0',
  `discord` varchar(50) DEFAULT NULL,
  `token` varchar(5000) DEFAULT NULL,
  `endpoint` varchar(50) DEFAULT NULL,
  `whitelist` tinyint(1) NOT NULL DEFAULT 0,
  `time_played` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`steam`) USING BTREE,
  KEY `steam` (`steam`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela clutch.accounts: ~3 rows (aproximadamente)
INSERT INTO `accounts` (`steam`, `discord`, `token`, `endpoint`, `whitelist`, `time_played`, `created_at`, `last_login`) VALUES
	('110000115524a16', NULL, '["2:cdfc2aeb68db4e605312712048cc4e466bf1dde5b74fe188143ad409c90232de","3:b22a05c466e538584f0a3d09ff51048e20284a65fcb96b94c9f1095843b17fde","4:7e99e216fa6e77bbe6634eba5331d0d063ce2809a52fd1dcf44db3926a876fdd","4:58c3efd01839576db6c15bc7e35819f816b291d825b1e1ee52d4f56794787b68","4:55d3beb1d583ec2ccd3f72133f0df0cc322661cf0a84551d3783478cd49a5aeb"]', '26.201.190.255', 1, 0, '2024-04-13 22:42:44', '2024-04-16 02:00:17'),
	('110000116e411ad', NULL, '["3:757a086d735801c4cfc8c5ce613689aae687d0c1a90e643ba6b63c12ad045eb2","5:cd0aba940e462f77585b836dd630b160f6cb25d1a2a48ff9102749ef89471987","4:ab864825a5c47cb29c52ee3554546b7edfd300386b8d4e3f2c9179f9efd2b159","4:91c31321ed85dfb9120a121708e8917a587ba81579af0efc39633961aefea838","4:58a3200d89ff9e3f61b8c559963409f3ed607903bd52be09fa6e5863b21c83d3"]', '26.151.244.75', 1, 0, '2024-04-04 03:50:30', '2024-04-17 07:24:52'),
	('1100001647b8d6e', NULL, '["5:6b318997d44755c45eb4b4a20a62db6562e6c0d263589475844d1f3bd929ed52","3:916a789514fe5454b81d0cbfe2d1a5756ca8eaab13a08eed32055f915a909b90","4:e06216670fe4edf9c20444c5788b16c6ba9483295a23046fef0516cf3427a1e3","4:82e1d16bf85b5b2291662ef2f2442e3edbcdbd7d89d372899f3f56705c7de0e8","4:277e787437c2b2ee8e7ebe1a009e4dd29f52c920e6ec54cbd4ff779be633efdf"]', '26.0.60.198', 1, 0, '2024-04-09 23:37:51', '2024-04-16 02:04:38');

-- Copiando estrutura para tabela clutch.bans
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(255) NOT NULL,
  `token` varchar(500) DEFAULT NULL,
  `reason` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL DEFAULT 'ban',
  `expire_time` int(11) DEFAULT NULL,
  `staff_id` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `steam` (`steam`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela clutch.bans: ~0 rows (aproximadamente)

-- Copiando estrutura para tabela clutch.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(100) DEFAULT NULL,
  `surname` char(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela clutch.characters: ~3 rows (aproximadamente)
INSERT INTO `characters` (`id`, `steam`, `surname`, `created_at`) VALUES
	(1, '110000116e411ad', 'luccasrj', '2024-04-04 03:52:17'),
	(2, '1100001647b8d6e', 'FAIFAZ', '2024-04-09 23:39:12'),
	(3, '110000115524a16', 'Bruno', '2024-04-13 22:49:16');

-- Copiando estrutura para tabela clutch.characters_data
CREATE TABLE IF NOT EXISTS `characters_data` (
  `user_id` int(11) NOT NULL,
  `dkey` varchar(100) NOT NULL,
  `dvalue` text DEFAULT NULL,
  PRIMARY KEY (`user_id`,`dkey`),
  KEY `user_id` (`user_id`),
  KEY `dkey` (`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela clutch.characters_data: ~4 rows (aproximadamente)
INSERT INTO `characters_data` (`user_id`, `dkey`, `dvalue`) VALUES
	(1, 'Barbershop', '[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32]'),
	(1, 'Datatable', '{"health":400,"skin":1885233650}'),
	(2, 'Datatable', '{"health":200,"skin":1885233650}'),
	(3, 'Datatable', '{"health":200,"skin":1885233650}');

-- Copiando estrutura para tabela clutch.groups
CREATE TABLE IF NOT EXISTS `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `character_id` int(11) NOT NULL,
  `group` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`character_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela clutch.groups: ~6 rows (aproximadamente)
INSERT INTO `groups` (`id`, `character_id`, `group`, `created_at`) VALUES
	(8, 1, 'dev', '2024-04-05 01:05:38'),
	(9, 2, 'ceo', '2024-04-09 23:39:14'),
	(10, 2, 'booster', '2024-04-09 23:39:14'),
	(11, 3, 'ceo', '2024-04-13 22:49:18'),
	(12, 3, 'booster', '2024-04-13 22:49:18'),
	(13, 1, 'booster', '2024-04-15 22:43:45');

-- Copiando estrutura para tabela clutch.logs
CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `link` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela clutch.logs: ~9 rows (aproximadamente)
INSERT INTO `logs` (`id`, `name`, `link`) VALUES
	(1, 'usuario-conectou', 'https://discordapp.com/api/webhooks/1225296109736300564/HEnaovh3kLN4CBoepnd3Zy4YGMMGQjugrDpsft0KKSpacIZmAMDIjcAlurqpaIo699yq'),
	(2, 'usuario-desconectou', 'https://discordapp.com/api/webhooks/1225296194507640882/jidDIXnl8jJ0WCs1R62m1BTQJr-LJXyVleMwsoilnO9Stp48M6wVqbSqkREjwwhwPbHz'),
	(3, 'commands-kick', 'https://discordapp.com/api/webhooks/1225296341190709378/JWKo8hkNT_JxolrW7tjj4wVkFgx8WQes9ORP0EEn4g3eFShB5ImDy4GWOPMQYX2dBgvf'),
	(4, 'commands-ban', 'https://discordapp.com/api/webhooks/1225296440935452773/yTJiXKyg8t9jNRD6Z62GKVrxl1mp3AcLgLlhtQIHExWrie7EfaN7D9oBDUIpQCJvMNEO'),
	(5, 'commands-god', 'https://discordapp.com/api/webhooks/1225296519674986526/6pfG6swjpaYai_0xOofGC4AoiB13Hl7BMpkUXegxXQ3ryJJSXbkUCM9p0fElEuraoHBr'),
	(6, 'commands-rename', 'https://discordapp.com/api/webhooks/1225296645596512357/znQZ9gjANzDdDUwHGaObfb9GCT3u3KuJ7tH_akyK6ny05uwIn-fa73HK_o2mZ5NwRLIU'),
	(7, 'commands-tptome', 'https://discordapp.com/api/webhooks/1225296708397830238/jfj2XIBmPHYX9JTD96TWX0NODMuEHwXgVojpft-WVhdJoPgqRZXYejaK9Du0DvColet7'),
	(8, 'commands-unban', 'https://discordapp.com/api/webhooks/1225296750298796032/kyEKIAhps_sTc9nHU1iJsFhjKIWy5gsUvyzy16AYZDUm_kOkakZzYIX528yOeioJgc8R'),
	(9, 'commands-death', 'https://discordapp.com/api/webhooks/1225296799120756816/E5kEfUovYo5iY8FVbtqETQiUe3854yCeyV3bt8vN_NJFKgrhdSV4eYrvTeOa4w5ZcIwq');

-- Copiando estrutura para tabela clutch.punishments
CREATE TABLE IF NOT EXISTS `punishments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `category` varchar(50) NOT NULL DEFAULT 'ban',
  `duration` varchar(50) DEFAULT NULL,
  `comment` varchar(50) DEFAULT NULL,
  `is_active` int(11) DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Copiando dados para a tabela clutch.punishments: ~0 rows (aproximadamente)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
=======
-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for clutch
DROP DATABASE IF EXISTS `clutch`;
CREATE DATABASE IF NOT EXISTS `clutch` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `clutch`;

-- Dumping structure for table clutch.accounts
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE IF NOT EXISTS `accounts` (
  `steam` varchar(50) NOT NULL DEFAULT '0',
  `discord` varchar(50) DEFAULT NULL,
  `token` varchar(5000) DEFAULT NULL,
  `endpoint` varchar(50) DEFAULT NULL,
  `whitelist` tinyint(1) NOT NULL DEFAULT 0,
  `time_played` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`steam`) USING BTREE,
  KEY `steam` (`steam`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table clutch.bans
DROP TABLE IF EXISTS `bans`;
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(255) NOT NULL,
  `token` varchar(500) DEFAULT NULL,
  `reason` varchar(255) NOT NULL,
  `category` varchar(255) NOT NULL DEFAULT 'ban',
  `expire_time` int(11) DEFAULT NULL,
  `staff_id` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `steam` (`steam`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table clutch.characters
DROP TABLE IF EXISTS `characters`;
CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(100) DEFAULT NULL,
  `surname` char(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table clutch.characters_data
DROP TABLE IF EXISTS `characters_data`;
CREATE TABLE IF NOT EXISTS `characters_data` (
  `user_id` int(11) NOT NULL,
  `dkey` varchar(100) NOT NULL,
  `dvalue` text DEFAULT NULL,
  PRIMARY KEY (`user_id`,`dkey`),
  KEY `user_id` (`user_id`),
  KEY `dkey` (`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table clutch.groups
DROP TABLE IF EXISTS `groups`;
CREATE TABLE IF NOT EXISTS `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `character_id` int(11) NOT NULL,
  `group` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`character_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table clutch.logs
DROP TABLE IF EXISTS `logs`;
CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `link` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

-- Dumping structure for table clutch.punishments
DROP TABLE IF EXISTS `punishments`;
CREATE TABLE IF NOT EXISTS `punishments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `category` varchar(50) NOT NULL DEFAULT 'ban',
  `duration` varchar(50) DEFAULT NULL,
  `comment` varchar(50) DEFAULT NULL,
  `is_active` int(11) DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
>>>>>>> 82743f3f1f42e2fbc55aaee619f5841467bb1310
