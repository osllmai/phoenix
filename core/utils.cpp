#include "utils.h"


QUrl Utils::fromUserInput(const QString &userInput)
{
    if (!userInput.isEmpty()) {
        if (const QUrl result = QUrl::fromUserInput(userInput); result.isValid())
            return result;
    }
    return QUrl::fromUserInput("about:blank"_L1);
}
