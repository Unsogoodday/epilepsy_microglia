# Variables

PYTHON=python
SRC=src
DATA=data
RESULTS=results

# Default target
all : preprocess analysis figures

# 1. Preprocess raw data into .h5ad
$(DATA)/processed/done: $(DATA)/raw/*
  $(PYTHON) $(SRC)/preprocessing.py \
    --input $(DATA)/raw \
    --output $(DATA)/processed \
  touch $@

# 2. Integrate preprocessed data
$(DATA)/integrated/done: $(DATA)/processed/done
  $(PYTHON) $(SRC)/integration.py \
    --input $(DATA)/processed \
    --output $(DATA)/integrated
  touch $@

# 3. Subset desired cell types
$(DATA)/subset/done: $(DATA)/integrated/done
  $(PYTHON) $(SRC)/subset.py \
    --input $(DATA)/integrated \
    --output $(DATA)/subset \
  touch $@

# 4. Downstream analysis on overall data
$(RESULTS)/tables/integrated_done: $(DATA)/integrated/done 
  $(PYTHON) $(SRC)/analysis_integrated.py \
    --input $(DATA)/integrated \
    --output $(RESULTS)/tables
  touch $@

# 5. Downstream analysis on subset data
$(RESULTS)/tables/subset_done: $(DATA)/subset/done
	$(PYTHON) $(SRC)/analysis_subset.py \
		--input $(DATA)/subset \
		--output $(RESULTS)/tables
	touch $@

# 6. Generate plots and figures (needs both analyses)
$(RESULTS)/figures/done: $(RESULTS)/tables/integrated_done $(RESULTS)/tables/subset_done
	$(PYTHON) $(SRC)/plotting.py \
		--input $(RESULTS)/tables \
		--output $(RESULTS)/figures
	touch $@

# Alias so you can just run "make figures"
figures: $(RESULTS)/figures/done

# Utility: clean everything
clean:
	rm -rf $(DATA)/processed/* $(DATA)/integrated/* $(DATA)/subset/* \
	       $(RESULTS)/tables/* $(RESULTS)/figures/*

