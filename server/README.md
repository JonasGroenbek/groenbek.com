To run

```
cp ./server/.env.example ./server/.env
docker build -t groenbek_server ./server
docker run -p 3001:3001 groenbek_server
```
