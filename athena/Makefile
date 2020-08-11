# Makefile in /athena/
# Included in Top-Most Makefile

# ? ––––––––––––––––––––––––––––––––––––––––––––– VARs

PROJECTA := -p athena

# ? ––––––––––––––––––––––––––––––––––––––––––––– Default

abuild:
	$(CC) build $(PROJECTA)

a: abuild

# ? ––––––––––––––––––––––––––––––––––––––––––––– Misc

arun: abuild
	$(CC) run $(PROJECTA)

adoc: Cargo.toml
	$(CC) doc $(PROJECTA) --open &

acheck:
	$(CC) check $(PROJECTA)

atest:
	$(CC) test $(PROJECTA)
