import express from "express";

const app = express();

const PORT = 3000;

app.get("/", (req, res) => {
  res.json({
    message: "Hello kubernetes, from a container",
    service: "hello-node",
    pod: process.env.POD_NAME || "unknown",
    time: new Date().toISOString(),
  });
});

app.get("/user", (req, res) => {
  res.json({
    name: "kubernetes",
    work: "autometion",
    relation: "IT Service",
    time: new Date().toISOString(),
  });
});

app.get("/readyz", (req, res) => {
  res.status(200).send("ready");
});

app.get("/healthz", (req, res) => {
  res.status(200).send("ok");
});

app.listen(PORT, () => {
  console.log(`app lisining on port ${PORT}`);
});
