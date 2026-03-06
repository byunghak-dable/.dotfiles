FROM ubuntu:24.04

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000
ARG NODE_MAJOR=22

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV SHELL=/usr/bin/zsh
ENV HOME=/home/${USERNAME}

# 시스템 패키지 + neovim stable PPA
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl wget unzip ca-certificates locales sudo \
    zsh tmux stow \
    fzf ripgrep fd-find \
    software-properties-common \
  && add-apt-repository -y ppa:neovim-ppa/stable \
  && apt-get update && apt-get install -y neovim \
  && locale-gen en_US.UTF-8 \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# fd-find → fd symlink (Ubuntu는 fd-find으로 설치됨)
RUN ln -sf /usr/bin/fdfind /usr/local/bin/fd

# zoxide (공식 installer)
RUN curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# lazygit (GitHub releases)
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') \
  && curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
  && tar xf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit \
  && rm /tmp/lazygit.tar.gz

# git-delta (GitHub releases)
RUN DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*') \
  && curl -Lo /tmp/delta.deb "https://github.com/dandavison/delta/releases/latest/download/git-delta_${DELTA_VERSION}_amd64.deb" \
  && dpkg -i /tmp/delta.deb \
  && rm /tmp/delta.deb

# GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && apt-get update && apt-get install -y gh \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Node.js LTS (nodesource)
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - \
  && apt-get install -y nodejs \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# 비root 사용자 생성
RUN groupadd --gid ${USER_GID} ${USERNAME} \
  && useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /usr/bin/zsh ${USERNAME} \
  && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${USERNAME}

# Claude Code CLI
USER ${USERNAME}
RUN npm install -g @anthropic-ai/claude-code

# zinit (zsh 플러그인 매니저)
RUN bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)" -- --no-modify-rc

WORKDIR ${HOME}

COPY --chown=${USERNAME}:${USERNAME} scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
