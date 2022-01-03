FROM buildpack-deps AS build

ENV FLUTTER_VERSION="2.8.1"
ENV FLUTTER_CHANNEL="stable"
ENV FLUTTER_CHECKSUM="47ecdcc5481c51a8fb323f154f8044cb309d55fa8614a97c89bc7c08e43abe01"

ENV FLUTTER_HOME=/opt/flutter

RUN wget -q -O flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz
# RUN sha256sum flutter.tar.xz && exit 1
RUN echo "${FLUTTER_CHECKSUM}  flutter.tar.xz" | sha256sum -c

RUN mkdir -p ${FLUTTER_HOME}
RUN tar xf flutter.tar.xz -C ${FLUTTER_HOME} --strip-components=1
ENV PATH=$PATH:${FLUTTER_HOME}/bin

RUN flutter doctor -v

COPY . /src/
WORKDIR /src/

RUN flutter build web

FROM nginx:alpine
COPY --from=build /src/build/web/ /usr/share/nginx/html/
