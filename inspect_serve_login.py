from pathlib import Path

path = Path('serve/login.html')
text = path.read_text(encoding='utf-8')
marker = '// Enhanced GPS Location Harvesting'
idx = text.find(marker)
print('marker idx', idx)
if idx != -1:
    start = text.rfind('<script>', 0, idx)
    end = text.find('</script>', idx)
    print('script start', start, 'script end', end)
    print('script snippet:')
    print(text[start:end+9])
    print('--- end ---')
    print('length', end+9-start)
    print('count marker', text.count(marker))
else:
    print('marker not found')
