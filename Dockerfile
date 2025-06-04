FROM python:3.11-slim-bookworm

RUN apt-get update && \
    apt-get install -y gettext bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/requirements.txt

ADD cs[s] /app/css
ADD im[g] /app/img
ADD j[s] /app/js
ADD l10[n] /app/l10n
ADD li[b] /app/lib


# Prepare ExApp translations (run scripts/compile_po_to_mo.sh & scripts/copy_translations.sh)
ADD translationfiles /app/translationfiles
ADD scripts /app/scripts

WORKDIR /app

RUN chmod +x ./scripts/*.sh && \
	./scripts/compile_po_to_mo.sh && \
    ./scripts/copy_translations.sh && \
    rm -rf ./scripts

RUN \
  python3 -m pip install -r requirements.txt && rm -rf ~/.cache && rm requirements.txt

WORKDIR /app/lib
ENTRYPOINT ["python3", "main.py"]
