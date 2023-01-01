# Steps to build the docker image:
#
#     docker build -t dev .
#
#     docker container run --interactive --tty --rm --name dev_container dev
#     v
#     # in parallel shell:
#           # docker commit dev_container dev
#     exit
#
# Instantiate to a container:
#     docker container run --rm --interactive --tty --volume $HOME/repo/ClickHouse1:/ClickHouse1 dev

FROM ubuntu:22.10

# Preparation: update system packages and install stuff needed for downloads and clones
RUN apt-get update \
    && apt-get upgrade \
    && apt-get --assume-yes --no-install-recommends install \
        ca-certificates \
        git \
        curl

# Install dotfiles
RUN rm -rf /root && mkdir /root \
    && git clone https://github.com/rschu1ze/dotfiles.git ~ \
    # Avoid auto-autoinstallation of these two files by .bashrc (part of the dotfiles) at runtime
    && curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > ~/.git-prompt.sh \
    && curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.git-completion.bash \
    # fix bash warning about locale
    && apt-get --assume-yes --no-install-recommends install locales && locale-gen en_US.UTF-8

# ClickHouse dependencies
# Cf. https://clickhouse.com/docs/en/development/build
RUN apt-get --assume-yes --no-install-recommends install \
    cmake \
    ninja-build \
    ccache \
    # Latest LLVM + clang + tools instead of the one provided by the distribution
    # Cf. https://apt.llvm.org/
    && apt-get --assume-yes --no-install-recommends install wget lsb-release software-properties-common gnupg \
    && bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

# Install Neovim
#     First, install official neovim dependencies on Ubuntu
#     Cf. https://github.com/neovim/neovim/wiki/Building-Neovim#ubuntu--debian
RUN apt-get --assume-yes --no-install-recommends install \
        ninja-build \
        gettext \
        libtool \
        libtool-bin \
        autoconf \
        automake \
        cmake \
        g++ \
        pkg-config \
        unzip \
        curl \
        doxygen \
    # Install additionally required make
    && apt-get --assume-yes --no-install-recommends install make \
    # Clone, compile and install
    && git clone https://github.com/neovim/neovim \
    && cd neovim && make CMAKE_BUILD_TYPE=Release && make install \
    # Remove development dependencies
    && apt-get --assume-yes remove \
        autoconf \
        automake \
        g++ \
        doxygen

# TODO debugging?
# TODO ccache
# TODO re-setup AWS box
# TODO change immediately to source directory, e.g. CMD no... ENTRYPOINT
