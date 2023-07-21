ARG MODEL=llama-2-13b-chat.ggmlv3.q4_0.bin

FROM ubuntu:22.04 AS builder
ARG MODEL

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y build-essential git wget

# Thanks to Adrien Brault (https://gist.github.com/adrienbrault/b76631c56c736def9bc1bc2167b5d129)
RUN git clone https://github.com/ggerganov/llama.cpp.git && cd llama.cpp && make

WORKDIR /llama.cpp

ENV MODEL=$MODEL
RUN wget "https://huggingface.co/TheBloke/Llama-2-13B-chat-GGML/resolve/main/${MODEL}"

FROM ubuntu:22.04 AS final
ARG MODEL

ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser
USER appuser

COPY --from=builder /llama.cpp /llama.cpp

WORKDIR /llama.cpp

ENV MODEL=$MODEL
ENV PROMPT="Tell me a joke with a lama"

ENTRYPOINT ./main -t 8 -ngl 1 -m ${MODEL} --color -c 2048 --temp 0.7 --repeat_penalty 1.1 -n -1 -p "[PROMPT] ${PROMPT} [/PROMPT]"
