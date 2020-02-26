from os.path import join

DATA_DIR = "data"
RAW_DIR = join(DATA_DIR, "raw")
PROCESSED_DIR = join(DATA_DIR, "processed")

DATA_SOURCE = "Karimzadeh2018"

K = 100
BLACKLIST_FILE = f"{DATA_SOURCE}-{{assembly}}-k{K}.umap.bed"
BLACKLIST_FILE_URL = f"https://bismap.hoffmanlab.org/raw/{{assembly}}/k{K}.umap.bed.gz"

ASSEMBLIES = [
    "hg38",
    "hg19",
    "mm10",
    "mm9"
]

rule all:
    input:
        expand(
            join(PROCESSED_DIR, f"{BLACKLIST_FILE}.multires"),
            assembly=ASSEMBLIES
        )

rule clodius:
    input:
        join(RAW_DIR, BLACKLIST_FILE)
    output:
        join(PROCESSED_DIR, f"{BLACKLIST_FILE}.multires")
    shell:
        """
        clodius aggregate bedfile \
            --has-header \
            --assembly {wildcards.assembly} \
            --output-file {output} \
            {input}
        """

rule download:
    output:
        join(RAW_DIR, BLACKLIST_FILE)
    params:
        file_url=BLACKLIST_FILE_URL
    shell:
        """
        curl -L -o {output}.gz {params.file_url} && gunzip {output}.gz
        """