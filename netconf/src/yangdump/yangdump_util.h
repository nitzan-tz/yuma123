/*
 * Copyright (c) 2009, Netconf Central, Inc.
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.    
 */
#ifndef _H_yangdump_util
#define _H_yangdump_util

/*  FILE: yangdump_util.h
*********************************************************************
*								    *
*			 P U R P O S E				    *
*								    *
*********************************************************************

  YANGDUMP utilities
 
*********************************************************************
*								    *
*		   C H A N G E	 H I S T O R Y			    *
*								    *
*********************************************************************

date	     init     comment
----------------------------------------------------------------------
23-oct-09    abb      Begun

*/

#ifndef _H_ses
#include "ses.h"
#endif

/********************************************************************
*								    *
*			 C O N S T A N T S			    *
*								    *
*********************************************************************/

/********************************************************************
*								    *
*			     T Y P E S				    *
*								    *
*********************************************************************/


/********************************************************************
* write_banner
*
* Write the yangdump startup banner 
*
*********************************************************************/
extern void 
    write_banner (void);


/********************************************************************
* write_banner_session
*
* Write the yangdump startup banner to a session
*
* INPUTS:
*   scb == session control block to use
*
*********************************************************************/
extern void 
    write_banner_session (ses_cb_t *scb);


/********************************************************************
 * FUNCTION find_reference
 * 
 *   Find the next 'RFC' or 'draft-' string in the buffer
 *   Find the end of the RFC or draft name
 *
 * INPUTS:
 *   buffer == buffer containing reference clause to use
 *   ref == address of return start pointer
 *   reflen == addredd of return 'ref' length
 *
 * OUTPUTS:
 *   *ref == address of start of reference word
 *        == NULL if no RFC xxxx of draft- found
 *   *reflen == number of chars in *ref, or 0 if *ref is NULL
 *
 * RETURNS:
 *   total number of chars processed
 *********************************************************************/
extern uint32
    find_reference (const xmlChar *buffer,
                    const xmlChar **ref,
                    uint32 *reflen);

#endif	    /* _H_yangdump_util */
