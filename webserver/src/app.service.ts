import { Injectable } from '@nestjs/common';
import { SESClient, SendEmailCommand } from '@aws-sdk/client-ses';

interface props {
  senderEmail: string;
  toEmail: string;
}

@Injectable()
export class AppService {
  async sendMail({ senderEmail, toEmail }: props) {
    const sesClient = new SESClient({ region: 'eu-west' });
    const paramsForEmail = {
      Destination: {
        ToAddresses: [toEmail],
      },
      Message: {
        Body: {
          Html: {
            Charset: 'UTF-8',
            Data: `
                    <p>              
                      Hello world!
                    </p>
                    `,
          },
        },
        Subject: { Data: 'Hello World' },
      },
      Source: senderEmail,
      ReturnPath: senderEmail,
    };
    const resultEmail = await sesClient.send(
      new SendEmailCommand(paramsForEmail),
    );
    sesClient.destroy();
  }
}
