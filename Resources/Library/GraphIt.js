mermaid.mermaidAPI.initialize({
  securityLevel: 'loose',
  theme: 'dark',
});

async function updateDiagram(code) {
    const mermaidElem = document.createElement('div');
    mermaidElem.id = 'mermaid';
    mermaidElem.className = 'mermaid';
    const { svg } = await mermaid.mermaidAPI.render('mermaid', code);
    mermaidElem.innerHTML = svg;
    document.body.appendChild(mermaidElem)
}
