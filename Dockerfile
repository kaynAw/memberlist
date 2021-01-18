FROM golang:1.13.8-alpine3.10 AS builder
ENV GO111MODULE=on \
	GOPROXY=https://goproxy.cn \
	GOFLAGS='-mod=vendor'
WORKDIR /go/src/app
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64  go build -o memberlist .

FROM alpine:3.11
COPY --from=builder /go/src/app/memberlist /memberlist
RUN chmod +x /memberlist

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENTRYPOINT ["/memberlist"]
