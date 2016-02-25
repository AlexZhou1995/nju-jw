/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50621
Source Host           : localhost:3306
Source Database       : njujw

Target Server Type    : MYSQL
Target Server Version : 50621
File Encoding         : 65001

Date: 2014-12-30 01:49:21
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for account
-- ----------------------------
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account` (
  `username` char(20) NOT NULL,
  `password` char(32) NOT NULL,
  `usertype` int(11) NOT NULL,
  `userno` int(11) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of account
-- ----------------------------
INSERT INTO `account` VALUES ('121232012', 'e10adc3949ba59abbe56e057f20f883e', '0', '121232012');
INSERT INTO `account` VALUES ('121242009', 'e10adc3949ba59abbe56e057f20f883e', '0', '121242009');
INSERT INTO `account` VALUES ('121242013', 'e10adc3949ba59abbe56e057f20f883e', '0', '121242013');
INSERT INTO `account` VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', '2', '888888');
INSERT INTO `account` VALUES ('manager', 'e10adc3949ba59abbe56e057f20f883e', '3', '-1');
INSERT INTO `account` VALUES ('teacher', 'e10adc3949ba59abbe56e057f20f883e', '1', '12345');

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `ano` int(11) NOT NULL,
  `name` char(10) NOT NULL,
  `dno` int(11) NOT NULL,
  PRIMARY KEY (`ano`),
  KEY `ad` (`dno`),
  CONSTRAINT `ad` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('888888', '王芳', '0');

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
  `cno` int(11) NOT NULL,
  `dno` int(11) NOT NULL,
  `name` char(20) NOT NULL,
  `credit` int(11) NOT NULL,
  `place_time` varchar(255) NOT NULL,
  PRIMARY KEY (`cno`),
  KEY `cd` (`dno`),
  CONSTRAINT `cd` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES ('22010001', '0', '高等数学', '3', '仙1-102');
INSERT INTO `course` VALUES ('22010002', '0', '大学物理', '4', '逸夫楼B201');
INSERT INTO `course` VALUES ('22010003', '0', '大学化学', '2', '仙2-305');
INSERT INTO `course` VALUES ('22010004', '0', '文学鉴赏', '2', '逸夫楼B310');
INSERT INTO `course` VALUES ('22010530', '1', '并行处理技术', '2', '周二 第5-6节 1-18周 仙Ⅱ-218');
INSERT INTO `course` VALUES ('22010540', '1', '数学建模', '2', '周二 第7-8节 1-18周 仙Ⅱ-218');
INSERT INTO `course` VALUES ('22010730', '1', 'Linux系统分析', '2', '周一 第5-6节 单周 逸B-211');
INSERT INTO `course` VALUES ('22020240', '1', '计算机网络', '2', '周三 第3-4节 1-18周 计算机楼227');
INSERT INTO `course` VALUES ('22020250', '1', '数据库概论', '2', '周五 第5-6节 1-18周 计算机楼227');
INSERT INTO `course` VALUES ('24020020', '0', '理论物理', '4', '周一 第5-6节 逸B-209 1-18周 周三 第5-6节 逸B-209 1-18周');
INSERT INTO `course` VALUES ('24020060', '0', '交叉学科前沿进展', '2', '');
INSERT INTO `course` VALUES ('24020070', '0', '电动力学', '3', '周一 第5-7节 仙Ⅰ-203 1-18周');
INSERT INTO `course` VALUES ('91220010', '1', '万维网科学', '2', '周一 第7-8节 仙Ⅱ-215 1-18周');
INSERT INTO `course` VALUES ('91220020', '1', 'Web程序分析测试', '2', '周五 第7-8节 仙Ⅱ-215 1-18周');

-- ----------------------------
-- Table structure for dc
-- ----------------------------
DROP TABLE IF EXISTS `dc`;
CREATE TABLE `dc` (
  `dno` int(11) DEFAULT NULL,
  `cno` int(11) NOT NULL,
  PRIMARY KEY (`cno`),
  KEY `dcd` (`dno`),
  CONSTRAINT `dcc` FOREIGN KEY (`cno`) REFERENCES `course` (`cno`) ON UPDATE CASCADE,
  CONSTRAINT `dcd` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dc
-- ----------------------------

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department` (
  `dno` int(11) NOT NULL,
  `dname` char(20) NOT NULL,
  PRIMARY KEY (`dno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of department
-- ----------------------------
INSERT INTO `department` VALUES ('0', '匡亚明学院');
INSERT INTO `department` VALUES ('1', '计算机科学与技术系');

-- ----------------------------
-- Table structure for dga
-- ----------------------------
DROP TABLE IF EXISTS `dga`;
CREATE TABLE `dga` (
  `dno` int(11) NOT NULL,
  `grade` varchar(255) NOT NULL,
  `ano` int(11) NOT NULL,
  PRIMARY KEY (`dno`,`grade`),
  KEY `dgaa` (`ano`),
  CONSTRAINT `dgaa` FOREIGN KEY (`ano`) REFERENCES `admin` (`ano`) ON UPDATE CASCADE,
  CONSTRAINT `dgad` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dga
-- ----------------------------

-- ----------------------------
-- Table structure for dt
-- ----------------------------
DROP TABLE IF EXISTS `dt`;
CREATE TABLE `dt` (
  `dno` int(11) NOT NULL,
  `tno` int(11) NOT NULL,
  PRIMARY KEY (`tno`),
  KEY `dtd` (`dno`),
  CONSTRAINT `dtd` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON UPDATE CASCADE,
  CONSTRAINT `dtt` FOREIGN KEY (`tno`) REFERENCES `teacher` (`tno`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt
-- ----------------------------

-- ----------------------------
-- Table structure for major
-- ----------------------------
DROP TABLE IF EXISTS `major`;
CREATE TABLE `major` (
  `mno` int(11) NOT NULL,
  `mname` char(20) NOT NULL,
  `dno` int(11) NOT NULL,
  PRIMARY KEY (`mno`,`dno`),
  KEY `md` (`dno`),
  CONSTRAINT `md` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of major
-- ----------------------------
INSERT INTO `major` VALUES ('0', '计算机方向', '0');
INSERT INTO `major` VALUES ('0', '计算机基础班', '1');
INSERT INTO `major` VALUES ('1', '数学方向', '0');
INSERT INTO `major` VALUES ('1', '计算机拔尖班', '1');
INSERT INTO `major` VALUES ('2', '物理方向', '0');
INSERT INTO `major` VALUES ('3', '化学方向', '0');

-- ----------------------------
-- Table structure for manager
-- ----------------------------
DROP TABLE IF EXISTS `manager`;
CREATE TABLE `manager` (
  `mno` int(11) NOT NULL,
  `name` char(20) NOT NULL,
  PRIMARY KEY (`mno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of manager
-- ----------------------------
INSERT INTO `manager` VALUES ('-1', '习近平');

-- ----------------------------
-- Table structure for publishment
-- ----------------------------
DROP TABLE IF EXISTS `publishment`;
CREATE TABLE `publishment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` char(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of publishment
-- ----------------------------
INSERT INTO `publishment` VALUES ('1', '第一条公告');
INSERT INTO `publishment` VALUES ('2', '第二条公告');
INSERT INTO `publishment` VALUES ('3', '第三条公告');

-- ----------------------------
-- Table structure for sc
-- ----------------------------
DROP TABLE IF EXISTS `sc`;
CREATE TABLE `sc` (
  `sno` int(11) NOT NULL,
  `cno` int(11) NOT NULL,
  `type` char(5) NOT NULL,
  `semester` char(5) NOT NULL,
  `score` int(11) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `review_score` smallint(6) DEFAULT NULL,
  `review_comment` varchar(255) DEFAULT NULL,
  `tno` int(11) NOT NULL,
  PRIMARY KEY (`sno`,`cno`,`semester`),
  KEY `scc` (`cno`),
  KEY `scsem` (`semester`),
  KEY `sctc` (`cno`,`semester`,`tno`),
  CONSTRAINT `scs` FOREIGN KEY (`sno`) REFERENCES `student` (`sno`) ON UPDATE CASCADE,
  CONSTRAINT `sctc` FOREIGN KEY (`cno`, `semester`, `tno`) REFERENCES `tc` (`cno`, `semester`, `tno`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sc
-- ----------------------------
INSERT INTO `sc` VALUES ('121220131', '22010001', '必修', '2012A', '80', null, null, null, '12345');
INSERT INTO `sc` VALUES ('121220131', '22010001', '必修', '2014A', null, null, null, null, '12123');
INSERT INTO `sc` VALUES ('121232012', '22010001', '必修', '2014A', null, null, null, null, '12123');
INSERT INTO `sc` VALUES ('121242004', '22010001', '必修', '2014A', null, null, null, null, '12123');
INSERT INTO `sc` VALUES ('121242007', '22010001', '必修', '2014A', null, null, null, null, '12123');
INSERT INTO `sc` VALUES ('121242009', '22010001', '必修', '2012A', '90', null, null, null, '12345');
INSERT INTO `sc` VALUES ('121242009', '22010001', '必修', '2014A', null, null, null, null, '12123');
INSERT INTO `sc` VALUES ('121242013', '22010001', '必修', '2014A', null, '', null, '', '12123');
INSERT INTO `sc` VALUES ('121242016', '22010001', '必修', '2014A', null, null, null, null, '12123');
INSERT INTO `sc` VALUES ('121242029', '22010001', '必修', '2014A', null, null, null, null, '12123');
INSERT INTO `sc` VALUES ('121242031', '22010001', '必修', '2012A', '60', null, null, null, '12345');
INSERT INTO `sc` VALUES ('121242031', '22010001', '必修', '2014A', null, null, null, null, '12123');

-- ----------------------------
-- Table structure for semester
-- ----------------------------
DROP TABLE IF EXISTS `semester`;
CREATE TABLE `semester` (
  `semno` char(6) NOT NULL,
  `current` tinyint(1) NOT NULL DEFAULT '0',
  `review` tinyint(1) NOT NULL DEFAULT '0',
  `course_select_control` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`semno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of semester
-- ----------------------------
INSERT INTO `semester` VALUES ('2012A', '0', '0', '0');
INSERT INTO `semester` VALUES ('2012B', '0', '0', '0');
INSERT INTO `semester` VALUES ('2013A', '0', '0', '0');
INSERT INTO `semester` VALUES ('2013B', '0', '0', '0');
INSERT INTO `semester` VALUES ('2014A', '1', '0', '1');
INSERT INTO `semester` VALUES ('2014B', '0', '0', '0');

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student` (
  `sno` int(11) NOT NULL,
  `name` char(10) NOT NULL,
  `sex` char(11) NOT NULL,
  `birthday` char(30) NOT NULL,
  `dno` int(11) NOT NULL,
  `mno` int(11) NOT NULL,
  `grade` int(11) NOT NULL,
  PRIMARY KEY (`sno`),
  KEY `sd` (`dno`),
  KEY `mno` (`mno`),
  CONSTRAINT `sd` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON UPDATE CASCADE,
  CONSTRAINT `sm` FOREIGN KEY (`mno`) REFERENCES `major` (`mno`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES ('121220022', '冯京浩', '女', '1994/3/12', '1', '0', '2012');
INSERT INTO `student` VALUES ('121220032', '何之真', '男', '1994/4/9', '1', '0', '2012');
INSERT INTO `student` VALUES ('121220035', '胡竞舟', '男', '1994/4/23', '1', '0', '2012');
INSERT INTO `student` VALUES ('121220038', '季志祥', '男', '1994/5/21', '1', '0', '2012');
INSERT INTO `student` VALUES ('121220041', '金大宇', '男', '1994/6/4', '1', '0', '2012');
INSERT INTO `student` VALUES ('121220044', '李昊轩', '男', '1994/7/16', '1', '0', '2012');
INSERT INTO `student` VALUES ('121220046', '李猛', '男', '1994/7/30', '1', '0', '2012');
INSERT INTO `student` VALUES ('121220094', '王珏', '男', '1994/9/24', '1', '0', '2012');
INSERT INTO `student` VALUES ('121220101', '王祚华', '女', '1994/10/8', '1', '0', '2012');
INSERT INTO `student` VALUES ('121220113', '徐悦', '女', '1994/10/22', '1', '0', '2012');
INSERT INTO `student` VALUES ('121220131', '张博栋', '男', '1994/11/19', '0', '0', '2012');
INSERT INTO `student` VALUES ('121220133', '张纯龙', '男', '1994/12/3', '1', '0', '2012');
INSERT INTO `student` VALUES ('121220151', '周琳', '女', '1994/12/17', '1', '0', '2012');
INSERT INTO `student` VALUES ('121220158', '朱凌墨', '男', '1995/1/14', '1', '0', '2012');
INSERT INTO `student` VALUES ('121220303', '陈龙意', '男', '1994/1/15', '1', '1', '2012');
INSERT INTO `student` VALUES ('121220305', '丁文韬', '男', '1994/2/26', '1', '1', '2012');
INSERT INTO `student` VALUES ('121220307', '金鑫', '男', '1994/6/18', '1', '1', '2012');
INSERT INTO `student` VALUES ('121220308', '康望程', '男', '1994/7/2', '1', '1', '2012');
INSERT INTO `student` VALUES ('121220319', '朱维希', '男', '1995/1/28', '1', '1', '2012');
INSERT INTO `student` VALUES ('121220320', '唐家宇', '男', '1994/9/10', '1', '1', '2012');
INSERT INTO `student` VALUES ('121232012', '周文吉', '男', '1994/12/31', '0', '1', '2012');
INSERT INTO `student` VALUES ('121242004', '查瀚文', '男', '1994/1/1', '0', '2', '2012');
INSERT INTO `student` VALUES ('121242007', '陈元', '男', '1994/1/29', '0', '3', '2012');
INSERT INTO `student` VALUES ('121242009', '丁顺杰', '男', '1994/2/12', '0', '0', '2012');
INSERT INTO `student` VALUES ('121242013', '傅宇', '男', '1994/3/14', '0', '1', '2012');
INSERT INTO `student` VALUES ('121242016', '黄萱', '男', '1994/5/7', '0', '2', '2012');
INSERT INTO `student` VALUES ('121242029', '马怀先', '男', '1994/8/13', '0', '3', '2012');
INSERT INTO `student` VALUES ('121242031', '秦硕', '男', '1994/8/27', '0', '0', '2012');
INSERT INTO `student` VALUES ('121242067', '朱希伟', '男', '1995/2/11', '1', '1', '2012');
INSERT INTO `student` VALUES ('121250198', '袁延钊', '男', '1994/11/5', '1', '1', '2012');

-- ----------------------------
-- Table structure for tc
-- ----------------------------
DROP TABLE IF EXISTS `tc`;
CREATE TABLE `tc` (
  `tno` int(11) NOT NULL,
  `cno` int(11) NOT NULL,
  `semester` char(5) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `select_control` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tno`,`cno`,`semester`),
  KEY `tcc` (`cno`),
  KEY `cno` (`cno`,`semester`),
  CONSTRAINT `tcc` FOREIGN KEY (`cno`) REFERENCES `course` (`cno`) ON UPDATE CASCADE,
  CONSTRAINT `tct` FOREIGN KEY (`tno`) REFERENCES `teacher` (`tno`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tc
-- ----------------------------
INSERT INTO `tc` VALUES ('12123', '22010001', '2014A', null, '0');
INSERT INTO `tc` VALUES ('12345', '22010001', '2012A', null, '1');

-- ----------------------------
-- Table structure for teacher
-- ----------------------------
DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher` (
  `tno` int(11) NOT NULL,
  `name` char(10) NOT NULL,
  `sex` char(11) NOT NULL,
  `birthday` char(30) NOT NULL,
  `dno` int(11) NOT NULL,
  PRIMARY KEY (`tno`),
  KEY `td` (`dno`),
  CONSTRAINT `td` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES ('12123', 'Alex', '女', '1980-10-10', '0');
INSERT INTO `teacher` VALUES ('12345', 'Jack', '男', '1978-10-10', '0');
INSERT INTO `teacher` VALUES ('123123', 'James', '男', '1989-10-10', '1');

-- ----------------------------
-- Table structure for write-off
-- ----------------------------
DROP TABLE IF EXISTS `write-off`;
CREATE TABLE `write-off` (
  `sno` int(11) NOT NULL,
  `cno` int(11) NOT NULL,
  `semester` char(5) NOT NULL,
  `dno` int(11) NOT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`sno`,`cno`,`semester`),
  KEY `wos` (`sno`),
  KEY `woc` (`cno`),
  KEY `wod` (`dno`),
  CONSTRAINT `wod` FOREIGN KEY (`dno`) REFERENCES `department` (`dno`) ON UPDATE CASCADE,
  CONSTRAINT `wosc` FOREIGN KEY (`sno`, `cno`, `semester`) REFERENCES `sc` (`sno`, `cno`, `semester`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of write-off
-- ----------------------------

-- ----------------------------
-- View structure for sc-full
-- ----------------------------
DROP VIEW IF EXISTS `sc-full`;
CREATE VIEW `sc-full` AS select `sc`.`sno` AS `sno`,`sc`.`cno` AS `cno`,`sc`.`type` AS `type`,`sc`.`semester` AS `semester`,`sc`.`score` AS `score`,`sc`.`remark` AS `remark`,`sc`.`review_score` AS `review_score`,`sc`.`review_comment` AS `review_comment`,`course`.`name` AS `cname`,`student`.`name` AS `sname`,`course`.`credit` AS `credit` from ((`sc` join `course` on((`sc`.`cno` = `course`.`cno`))) join `student` on((`sc`.`sno` = `student`.`sno`))) ;

-- ----------------------------
-- View structure for tc-full
-- ----------------------------
DROP VIEW IF EXISTS `tc-full`;
CREATE VIEW `tc-full` AS select `tc`.`tno` AS `tno`,`tc`.`cno` AS `cno`,`tc`.`semester` AS `semester`,`tc`.`remark` AS `remark`,`course`.`name` AS `cname`,`teacher`.`name` AS `tname`,`course`.`credit` AS `credit`,`course`.`place_time` AS `place_time`,`course`.`dno` AS `dno`,`tc`.`select_control` AS `select_control` from ((`tc` join `course` on((`tc`.`cno` = `course`.`cno`))) join `teacher` on((`tc`.`tno` = `teacher`.`tno`))) ;

-- ----------------------------
-- View structure for write-off-full
-- ----------------------------
DROP VIEW IF EXISTS `write-off-full`;
CREATE VIEW `write-off-full` AS select `write-off`.`sno` AS `sno`,`write-off`.`cno` AS `cno`,`write-off`.`semester` AS `semester`,`write-off`.`dno` AS `dno`,`write-off`.`remark` AS `remark`,`student`.`name` AS `sname`,`course`.`name` AS `cname` from ((`write-off` join `student` on((`student`.`sno` = `write-off`.`sno`))) join `course` on((`write-off`.`cno` = `course`.`cno`))) ;
