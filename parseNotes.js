(async () => {
  const noteTable = {
    '1':72,'#1':73,'1s':73,'1f':73,'b1':73,'b2':73,
    '2':74,'#2':75,'2s':75,'2f':75,'b3':75,
    '3':76,'#3':76,'3s':76,'3f':76,'b4':76,
    '4':77,'#4':78,'4s':78,'4f':78,'b5':78,
    '5':79,'#5':80,'5s':80,'5f':80,'b6':80,
    '6':81,'#6':82,'6s':82,'6f':82,'b7':82,
    '7':83,'7f':85,'7s':85,'#7':85
  };

  function parseJSONNotes(data) {
    const bpm = data.tempos[0].bpm;
    const tempo = Math.round(60000 / bpm);

    let position = data.notes[0].beat;
    let notes = [];

    for (let i = 0; i < data.notes.length; i++) {
      const cn = data.notes[i];

      if (position !== cn.beat) {
        const diff = cn.beat - position;
        if (i > 0)
          notes[i - 1][1] += Math.floor(diff * tempo);
        position += diff;
      }

      const octave = Number(cn.octave);
      const note = Math.floor(
        noteTable[cn.sd] + 12 * (isNaN(octave) ? 0 : octave - 1)
      );

      if (isNaN(note))
        console.warn(`Erro na nota ${i}:`, cn);

      notes.push([
        note,
        Math.floor(cn.duration * tempo)
      ]);

      position += cn.duration;
    }

    const out = notes.flat().join(",");
    return [out.split(",").length / 2, out];
  }

  function parseXMLNotes(xml) {
    const get = (n, k) => n.querySelector(k).textContent;

    const bpm = Number(get(xml, "BPM") || get(xml, "bpm"));
    const tempo = Math.round(60000 / bpm);

    const list = [...xml.querySelectorAll("note")];
    let notes = [];

    for (const n of list) {

      if (Number(get(n, "isRest"))) {
        if (notes.length)
          notes[notes.length - 1][1] +=
            Math.floor(parseFloat(get(n, "note_length")) * tempo);
        continue;
      }

      const octave = Number(get(n, "octave"));
      const note =
        noteTable[get(n, "scale_degree")] +
        12 * (isNaN(octave) ? 0 : octave - 1);

      notes.push([
        note,
        Math.floor(parseFloat(get(n, "note_length")) * tempo)
      ]);
    }

    const out = notes.flat().join(",");
    return [out.split(",").length / 2, out];
  }

  async function createNotes(id) {

    const json = await fetch(
      `https://api.hooktheory.com/v1/songs/public/${id}?fields=ID,xmlData,song,jsonData`,
      {
        credentials: "omit",
        mode: "cors"
      }
    ).then(r => r.json());

    if (json.xmlData) {
      const xml = new DOMParser().parseFromString(
        json.xmlData.replace(/%20/g, ""),
        "text/xml"
      );
      return parseXMLNotes(xml);
    }

    return parseJSONNotes(JSON.parse(json.jsonData));
  }

  // Procura todos os links que possuem idOfSong
  const songLinks = [...document.querySelectorAll("a[href*='idOfSong=']")];

  if (!songLinks.length) {
    console.error("Nenhuma música encontrada.");
    return;
  }

  const parts = {};

  for (const link of songLinks) {
    const url = new URL(link.href);
    const id = url.searchParams.get("idOfSong");

    if (!id) continue;

    const nome = link.textContent.trim() || id;

    try {
      parts[nome] = await createNotes(id);
      console.log("OK:", nome);
    } catch (e) {
      console.error(nome, e);
    }
  }

  console.log(parts);

  console.groupCollapsed("RESULTADO");

  Object.entries(parts).forEach(([k, v]) => {
    console.log(`${k}
TAMANHO: ${v[0]}
NOTAS:
${v[1]}
`);
  });

  console.groupEnd();

})();
