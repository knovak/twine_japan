function showCard(cardNumber) {
    // Hide all cards
    const cards = document.querySelectorAll('.card');
    cards.forEach(card => card.classList.remove('active'));
    
    // Show selected card
    const targetCard = document.getElementById(`card${cardNumber}`);
    if (targetCard) {
        targetCard.classList.add('active');
    }
}

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

// Initialize the first card as active when page loads
document.addEventListener('DOMContentLoaded', function() {
    // Show table of contents by default
    showCard(0);
});