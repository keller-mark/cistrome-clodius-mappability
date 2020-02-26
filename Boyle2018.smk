from os.path import join

DATA_DIR = "data"
RAW_DIR = join(DATA_DIR, "raw")
PROCESSED_DIR = join(DATA_DIR, "processed")

DATA_SOURCE = "Boyle2018"

BLACKLIST_FILE = f"{DATA_SOURCE}-{{assembly}}-blacklist.v2.bed"
BLACKLIST_FILE_URL = f"https://github.com/Boyle-Lab/Blacklist/raw/master/lists/{{assembly}}-blacklist.v2.bed.gz"

ASSEMBLIES = [
    "dm3",
    "dm6",
    "hg19",
    "hg38",
    "mm10"
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