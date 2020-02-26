Set up and activate conda environment:

```sh
conda env create -f environment.yml
source activate clodius-env
```

Run snakemake:

```sh
snakemake --snakefile Boyle2018.smk
snakemake --snakefile Karimzadeh2018.smk
```

Load the tilesets into higlass-server, assuming the directory looks like this:

```
parent_dir/
    higlass-server/
        manage.py
    cistrome-clodius-mappability/
        Boyle2018.smk
        Karimzadeh2018.smk
```

```sh
cd ../higlass-server

python manage.py ingest_tileset \
    --uid Boyle2018-hg19-blacklist \
    --filename ../cistrome-clodius-mappability/data/processed/Boyle2018-hg19-blacklist.v2.bed.multires \
    --filetype beddb \
    --datatype bedlike

python manage.py ingest_tileset \
    --uid Karimzadeh2018-hg19-blacklist \
    --filename ../cistrome-clodius-mappability/data/processed/Karimzadeh2018-hg19-k100.umap.bed.multires \--filetype beddb \
    --datatype bedlike
```