// Basic n8n integration for contact form
// Replace N8N_WEBHOOK_URL with your actual webhook URL (hardcoded or injected at build time)

const N8N_WEBHOOK_URL = 'https://your-n8n-instance/webhook/voltixio-contact'; // update this

document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('contactForm');
    const submitButton = document.getElementById('contactSubmit');
    const messageBox = document.getElementById('formMessage');

    if (!form) return;

    form.addEventListener('submit', async (event) => {
        event.preventDefault();

        if (!N8N_WEBHOOK_URL) {
            showMessage('Contact form is not configured yet.', 'error');
            return;
        }

        const formData = new FormData(form);
        const payload = Object.fromEntries(formData.entries());

        try {
            submitButton.disabled = true;
            showMessage('Sending your message...', 'info');

            const response = await fetch(N8N_WEBHOOK_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(payload)
            });

            if (!response.ok) {
                throw new Error(`Request failed with status ${response.status}`);
            }

            showMessage('Thanks! Your message has been sent.', 'success');
            form.reset();
        } catch (error) {
            console.error(error);
            showMessage('Something went wrong. Please try again.', 'error');
        } finally {
            submitButton.disabled = false;
        }
    });

    function showMessage(text, type) {
        if (!messageBox) return;
        messageBox.textContent = text;
        messageBox.className = 'form-message'; // reset
        if (type === 'success') messageBox.classList.add('success');
        if (type === 'error') messageBox.classList.add('error');
        if (type === 'info') messageBox.style.display = 'block';
        messageBox.style.display = 'block';
    }
});
