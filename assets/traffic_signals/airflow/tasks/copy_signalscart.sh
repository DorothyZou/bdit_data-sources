psql -U airflow -h localhost -p 5432 traffic_signals -c "COPY (SELECT * FROM public.signals_cart) TO STDOUT (FORMAT text, ENCODING 'UTF-8')" | psql -v ON_ERROR_STOP=1 -U vzairflow -h 10.160.12.47 -p 5432 bigdata -c "TRUNCATE vz_safety_programs_staging.signals_cart; COPY vz_safety_programs_staging.signals_cart FROM STDIN;"
