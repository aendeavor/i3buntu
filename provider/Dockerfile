# Packs compiled forwarding-application.
# Implicit multi-stage build from build script make.sh (Stage 2 / 2)

FROM scratch
USER 1000

COPY ./target/x86_64-unknown-linux-musl/release/provider /

CMD [ "/provider" ]
