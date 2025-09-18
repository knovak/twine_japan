function toggleLocation(locationId) {
    const content = document.getElementById(locationId);
    const iconId = locationId.replace('location', 'icon');
    const icon = document.getElementById(iconId);
    
    if (content && icon) {
        if (content.classList.contains('expanded')) {
            // Collapse
            content.classList.remove('expanded');
            icon.textContent = '+';
            icon.style.transform = 'rotate(0deg)';
        } else {
            // Expand
            content.classList.add('expanded');
            icon.textContent = '−';
            icon.style.transform = 'rotate(180deg)';
        }
    }
}

Config.passages.nobr = true;