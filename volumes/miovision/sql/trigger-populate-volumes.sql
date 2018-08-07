﻿CREATE OR REPLACE FUNCTION insert_volumes()
  RETURNS trigger AS
$BODY$

BEGIN


	INSERT INTO rliu.volumes (intersection_uid, datetime_bin, classification_uid, leg, movement_uid, volume)
	SELECT B.intersection_uid, (NEW.datetime_bin AT TIME ZONE 'America/Toronto') AS datetime_bin, C.classification_uid, NEW.entry_dir_name as leg, D.movement_uid, NEW.volume
	FROM miovision.intersections B 
	INNER JOIN miovision.movements D ON (D.movement = NEW.movement)
	INNER JOIN miovision.classifications C ON C.classification = NEW.classification AND C.location_only = D.location_only
	WHERE regexp_replace(NEW.study_name,'Yong\M','Yonge') = B.intersection_name
	RETURNING volume_uid INTO NEW.volume_uid;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION insert_volumes()
  OWNER TO rliu;
GRANT EXECUTE ON FUNCTION insert_volumes() TO public;
GRANT EXECUTE ON FUNCTION insert_volumes() TO dbadmin WITH GRANT OPTION;
GRANT EXECUTE ON FUNCTION insert_volumes() TO bdit_humans WITH GRANT OPTION;
GRANT EXECUTE ON FUNCTION insert_volumes() TO rliu;

CREATE TRIGGER insert_volumes_trigger
  BEFORE INSERT
  ON raw_data
  FOR EACH ROW
  EXECUTE PROCEDURE insert_volumes();
