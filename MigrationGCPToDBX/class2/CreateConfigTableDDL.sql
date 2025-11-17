---this file needs to be created in MYSQL workbench after cfeating connectivity between GCP MYSQL instance and local MYSQL workbench 

create database GCPmigrationMeta;

USE GCPmigrationMeta;


-- Drop old table if it exists (for clean setup)
DROP TABLE IF EXISTS GCPmigrationMeta.config_table;

CREATE TABLE config_table (
  id                     BIGINT PRIMARY KEY AUTO_INCREMENT,
  table_name             VARCHAR(200) NOT NULL,
  table_key              CHAR(40) AS (SHA1(table_name)) STORED,

  -- Source and targets
  source_project         VARCHAR(200) NOT NULL DEFAULT 'shaped-orbit-476811-g9',
  source_dataset         VARCHAR(200) NOT NULL,
  gcs_path               VARCHAR(500) NULL,                 -- path in GCS bucket
  target_path            VARCHAR(500) NOT NULL,             -- Delta target in Databricks

  -- Control flags
  active_flag            TINYINT(1) NOT NULL DEFAULT 1,
  load_flag              TINYINT(1) NOT NULL DEFAULT 1,

  -- Two-stage statuses
  bq_to_gcs_status       ENUM('NOT_STARTED','IN_PROGRESS','COMPLETED','FAILED') DEFAULT 'NOT_STARTED',
  gcs_to_bronze_status   ENUM('NOT_STARTED','IN_PROGRESS','COMPLETED','FAILED') DEFAULT 'NOT_STARTED',

  -- Common timestamps
  last_run_ts            DATETIME NULL,
  last_success_ts        DATETIME NULL,
  error_message          TEXT NULL,

  created_ts             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_ts             DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY uk_table_name (table_name)
);