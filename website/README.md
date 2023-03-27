To run

```
cp ./website/.env.example ./website/.env
docker build -t groenbek_website ./website
docker run -p 3000:3000 groenbek_website
```
