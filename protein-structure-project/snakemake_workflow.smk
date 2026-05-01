import os
from glob import glob

PDB_DIR = config["pdb_dir"]

FILES = [os.path.basename(x).replace(".pdb","") for x in glob(PDB_DIR+"/*.pdb")][:10000]

rule all:
    input:
        expand("results/angles/{id}.txt", id=FILES)

rule helix_extract:
    input:
        "stride_files/{id}.txt"
    output:
        "extracted/{id}.tsv"
    shell:
        """
        python scripts/get_helix_data.py {input} {output} ARG
        """

rule angle_calc:
    input:
        tsv="extracted/{id}.tsv",
        pdb=PDB_DIR + "/{id}.pdb"
    output:
        "results/angles/{id}.txt"
    shell:
        """
        python scripts/find_angles.py {input.tsv} {input.pdb} {output}
        """
