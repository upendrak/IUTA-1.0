FROM r-base:latest
MAINTAINER Upendra Devisetty <upendra@cyverse.org>
LABEL Description "This Dockerfile is for IUTA"

# Run updates
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install wget -y
RUN apt-get install r-base-dev -y
RUN apt-get install libxml2 -y
RUN apt-get install libxml2-dev -y

RUN wget http://www.niehs.nih.gov/resources/files/IUTA_1.0.tar.gz
RUN tar zxvf IUTA_1.0.tar.gz

RUN Rscript -e 'source("http://bioconductor.org/biocLite.R"); biocLite("Rsamtools");'
RUN Rscript -e 'install.packages("/IUTA_1.0.tar.gz", repos = NULL, type="source");'
RUN Rscript -e 'install.packages("getopt");'

ENV IUTAPA https://raw.githubusercontent.com/upendrak/IUTA/master/run_IUTA.R
RUN wget $IUTAPA
RUN chmod +x /run_IUTA.R && cp /run_IUTA.R /usr/bin

ENTRYPOINT ["run_IUTA.R"]
CMD ["-h"]

# Building and testing
# docker build -t"=rbase/iuta" .
# Running with out any arguments
# sudo docker run rbase/iuta -h
# With test data
# docker run --rm -v $(pwd):/working-dir -w /working-dir rbase/iuta --gtf mm10_kg_sample_IUTA.gtf --bam1 sample_1.bam,sample_2.bam,sample_3.bam --bam2 sample_4.bam,sample_5.bam,sample_6.bam --fld normal --test.type SKK,CQ,KY --output IUTA_test --groups 4,5 --gene.id Pcmtd1