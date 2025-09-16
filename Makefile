# Variables

PYTHON=python
SRC=src
DATA=data
RESULTS=results

# Default target
all : preprocess analysis figures

# 1. Preprocess raw data into .h5ad
preprocess:
  $(PYTHON) $(SRC)/preprocessing.py \
    --input $(DATA)/raw \
    --output $(DATA)/processed \

# 2. Run main analysis
analysis : 
  $(PYTHON) $(SRC)/analysis.py \
    --input $(DATA)/processed \
    --output $(RESULTS)/tables

# 3. Generate plots and figures
figures : 
  $(PYTHON) $(SRC)/plotting.py \
    --input $(RESULTS)/tables \
    --output $(RESULTS)/figures

# Remove intermediate outputs
clean : 
  rm -rf $(DATA)/processed/* $(RESULTS)/tables/* $(RESULTS)/figures/*
