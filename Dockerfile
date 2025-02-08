FROM oven/bun:1 as builder

WORKDIR /app

COPY package*.json bun.lock ./
RUN bun install --frozen-lockfile

COPY . .

RUN bun run build

FROM oven/bun:1-slim

WORKDIR /app

COPY package*.json bun.lock ./
RUN bun install --frozen-lockfile --production

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/src/server.js ./
COPY --from=builder /app/src/env.js ./

VOLUME ["/app/data"]

RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup
USER appuser

EXPOSE 3000

CMD ["bun", "server.js"]
