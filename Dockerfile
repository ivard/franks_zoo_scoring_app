FROM buildpack-deps AS build

ENV FLUTTER_VERSION="2.5.2"
ENV FLUTTER_CHANNEL="stable"
ENV FLUTTER_CHECKSUM="371234b5b9c127fcd3053b4b04e45c0024657d95f7371eb9d9422a7da5297717"

ENV FLUTTER_HOME=/opt/flutter

RUN wget -q -O flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz
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
