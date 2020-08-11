# Makefile in /hermes/
# Included in Top-Most Makefile

# ? ––––––––––––––––––––––––––––––––––––––––––––– VARs

PROJECTH := -p hermes

# ? ––––––––––––––––––––––––––––––––––––––––––––– Default

hbuild: Cargo.toml
	$(CC) build $(PROJECTH)

# ? ––––––––––––––––––––––––––––––––––––––––––––– Misc

hrun: hbuild
	$(CC) run $(PROJECTH)

hdoc: Cargo.toml
	$(CC) doc $(PROJECTH) --open &

hcheck:
	$(CC) check $(PROJECTH)

htest:
	$(CC) test $(PROJECTH)

# ? ––––––––––––––––––––––––––––––––––––––––––––– Release

hrelease: Cargo.toml
	@- ./hermes/make.sh --build

hpublish: hrelease
	@- ./hermes/make.sh --publish
