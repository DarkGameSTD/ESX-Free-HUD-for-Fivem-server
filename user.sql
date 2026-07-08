-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;



-- Dumping structure for table volta.hud_playlists
CREATE TABLE IF NOT EXISTS `hud_playlists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` longtext DEFAULT NULL,
  `name` longtext NOT NULL,
  `cover` longtext DEFAULT NULL,
  `likes` longtext NOT NULL,
  `creatorname` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table volta.hud_playlists: ~2 rows (approximately)
INSERT INTO `hud_playlists` (`id`, `owner`, `name`, `cover`, `likes`, `creatorname`) VALUES
	(20, 'steam:1100001327746c0', 'test', 'default', '[]', 'Fergal Wolf'),
	(21, 'steam:1100001327746c0', 'sss', 'default', '[]', 'Fergal Wolf');

-- Dumping structure for table volta.hud_playlist_songs
CREATE TABLE IF NOT EXISTS `hud_playlist_songs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `playlist_id` int(11) DEFAULT NULL,
  `url` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `name` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table volta.hud_playlist_songs: ~0 rows (approximately)

-- Dumping structure for table volta.hud_stress
CREATE TABLE IF NOT EXISTS `hud_stress` (
  `identifier` varchar(46) DEFAULT NULL,
  `stress` int(11) DEFAULT NULL,
  UNIQUE KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table volta.hud_stress: ~12 rows (approximately)
INSERT INTO `hud_stress` (`identifier`, `stress`) VALUES
	('steam:1100001433960ef', 0),
	('steam:11000015fd100c8', 0),
	('steam:110000135f04fcf', 0),
	('steam:11000016997383e', 0),
	('steam:1100001668f37de', 0),
	('steam:110000148e18c7d', 0),
	('steam:11000013daac28b', 11),
	('steam:1100001697b4363', 14),
	('steam:110000107fb7c81', 7),
	('steam:11000016cb3d590', 0),
	('steam:110000152b048e8', 47),
	('steam:110000149e090d5', 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
