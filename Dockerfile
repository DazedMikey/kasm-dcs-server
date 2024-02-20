FROM kasmweb/core-ubuntu-focal:1.15.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
ENV KASM_RX_HOME $STARTUPDIR/kasmrx
ENV DEBIAN_FRONTEND noninteractive

WORKDIR $HOME

######### Customize Container Here ###########

### Install Tools
COPY ./src/ubuntu/install/tools $INST_SCRIPTS/tools/
RUN bash $INST_SCRIPTS/tools/install_tools_deluxe.sh  && rm -rf $INST_SCRIPTS/tools/

# Install Utilities
COPY ./src/ubuntu/install/misc $INST_SCRIPTS/misc/
RUN bash $INST_SCRIPTS/misc/install_tools.sh && rm -rf $INST_SCRIPTS/misc/

# Setup sudo
RUN apt-get update \
    && apt-get install -y sudo \
    && echo 'kasm-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && rm -rf /var/lib/apt/list/*

# Setup Display
RUN apt install zenity xdotool -y
RUN apt install xfce4 xfce4-goodies -y
RUN apt install xvfb -y
RUN apt install winbind -y

# Copy DCS Dependecies Install Script and Run it
COPY ./scripts/new_dcs_dependencies.sh .
RUN chmod +x $HOME/new_dcs_dependencies.sh && $HOME/new_dcs_dependencies.sh

# Create desktop shortcut to start DCS
COPY ./scripts/start_dcs.sh .
COPY ./images/DCS_Icon.png .
COPY ./dcs.desktop .
RUN chmod +x $HOME/start_dcs.sh \
    && cp $HOME/dcs.desktop $HOME/Desktop/ \
    && chown 1000:1000 $HOME/Desktop/dcs.desktop

# Wallpaper
COPY ./images/f14_wallpaper.png /usr/share/backgrounds/bg_default.png

# Install Firefox
COPY ./src/ubuntu/install/firefox/ $INST_SCRIPTS/firefox/
COPY ./src/ubuntu/install/firefox/firefox.desktop $HOME/Desktop/
RUN bash $INST_SCRIPTS/firefox/install_firefox.sh && rm -rf $INST_SCRIPTS/firefox/

# Launch DCS automatically
RUN echo "/usr/bin/desktop_ready && $HOME/start_dcs.sh &" > $STARTUPDIR/custom_startup.sh \
    && chmod +x $STARTUPDIR/custom_startup.sh

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
