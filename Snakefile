from os.path import join

configfile: "config.yaml"

include: "./bwa_mem"
include: "./sam_to_bam"
include: "./fixmate"
include: "./sortsam"
include: "./markdup"
include: "./realigntargetcreator"
include: "./indelrealigner"
include: "./create_gVCF"
include: "./combine_gVCFs"
include: "./filtervariants_all"
include: "./alamutannotate"

fa = config["reference_genome"]
bwa = config["bwa"]
java = config["java"]
picard = config["picard"]
workbatch = config["workbatch"]
batchID = config["batchID"]
tempfolder = config["tempfolder"]
intervals = config["intervals"]
gatk = config["gatk"]
known_indels = config["known_indels"]
rscript = config["rscript"]
alamut = config["alamut"]
python=config["python"]
platypus=config["platypus"]


samples=config["samples"]

with open("sample_gVCF.list", "w") as gVCF_list:
   for sample, value in samples.items():
      line_to_write = workbatch + "/gVCF/" + sample + ".separate.gVCF" +  "\n"
      gVCF_list.write(line_to_write)      
      
with open("control", "w") as control:
   header_line = "v4_SnakeMake pipeline - M Johnson" + "\n" + "mj318@exeter.ac.uk" + "\n" + "\n" + workbatch + "\n" + "\n"
   control.write(header_line)
   for sample, value in samples.items():
      line_to_write =  batchID + "\n" + sample + "\n" + "\n"
      control.write(line_to_write)

rule all:
	input:
                 expand("{workbatch}/variants/batchID_annotated.txt", workbatch=workbatch,  batchID=batchID, sample=samples),
                 expand("{workbatch}/variants/batchID_unannotated.txt", workbatch=workbatch,  batchID=batchID, sample=samples),
