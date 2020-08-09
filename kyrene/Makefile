# Makefile in /kyrene/
# Included in Top-Most Makefile

# ? ––––––––––––––––––––––––––––––––––––––––––––– VARs

PROJECTK := -p kyrene

# ? ––––––––––––––––––––––––––––––––––––––––––––– Default

kbuild:
	$(CC) build $(PROJECTK)

k: kbuild

# ? ––––––––––––––––––––––––––––––––––––––––––––– Misc

krun: kbuild
	$(CC) run $(PROJECTK)

kdoc: Cargo.toml
	$(CC) doc $(PROJECTK) --open &

kcheck:
	$(CC) check $(PROJECTK)

ktest:
	$(CC) test $(PROJECTK)
