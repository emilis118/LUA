local sampev = require 'lib.samp.events'

function sampev.onSendChat(msg)
    sendDiscord(
        true,
        'https://discord.com/api/webhooks/811218614714761216/3ULm28B-k_n4ElCjaej6WTWbR8_SC1zMTQPpRflsQtP5UlhaXlOvbd578sKWW1fP6R9t',
        msg
    )
end

function sendDiscord(getName, sendUrl, text)
    local requests = require('lib.requests')
    local encoding = require 'encoding'
    encoding.default = 'cp1257'
    local u8 = encoding.UTF8
    local _, idas = false, 0
    if getName then
        _, idas = sampGetPlayerIdByCharHandle(PLAYER_PED)
    end
    local args = {
        username = '',
        content = ''
    }
    local headers = {['Content-Type'] = 'application/json'}
    args.username = sampGetPlayerNickname(idas)
    args.content = u8:encode(text)
    responses = requests.post {url = sendUrl, headers = headers, data = args}
end
