FROM perl:5.20-stretch

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /build
COPY . .

RUN cpanm --quiet --notest \
    App::FatPacker \
    Dist::Zilla \
    Perl::Critic \
    Perl::Tidy \
    File::Slurp

RUN dzil authordeps | xargs cpanm --quiet --notest
RUN dzil listdeps --develop | xargs cpanm --quiet --notest
