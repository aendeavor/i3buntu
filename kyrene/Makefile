# Makefile in /kyrene/
# Included in Top-Most Makefile

# ? ––––––––––––––––––––––––––––––––––––––––––––– VARs

PROJECTK := -p kyrene

# ? ––––––––––––––––––––––––––––––––––––––––––––– Default

kbuild:
	$(CC) build $(PROJECTK)

# ? ––––––––––––––––––––––––––––––––––––––––––––– Misc

krun: kbuild
	$(CC) run $(PROJECTK)

kdoc: Cargo.toml
	$(CC) doc $(PROJECTK) --open &

kcheck:
	$(CC) check $(PROJECTK)

ktest:
	$(CC) test $(PROJECTK)
